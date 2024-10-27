class SpotifySearchHandler {
  constructor() {
    // 検索関連の要素
    this.searchInput = document.getElementById('song_search');
    this.searchButton = document.getElementById('search-button');
    this.searchResults = document.getElementById('search-results');
    this.mainForm = this.searchInput?.closest('form');

    // 既にイベントリスナーが設定されているかのフラグ
    this.initialized = false;

    // 必要な要素が存在する場合のみ初期化
    if (this.searchInput && this.searchResults) {
      this.initialize();
    }
  }

  initialize() {
    if (this.initialized) return;

    // Enter キーのイベントを捕捉
    this.searchInput.addEventListener('keydown', this.handleKeyDown.bind(this));

    // 検索ボタンのクリックイベント
    if (this.searchButton) {
      this.searchButton.addEventListener('click', (e) => {
        e.preventDefault();
        this.handleSearch();
      });
    }

    // メインフォームのサブミット制御
    if (this.mainForm) {
      this.mainForm.addEventListener('submit', (e) => {
        const activeElement = document.activeElement;
        if (activeElement === this.searchInput) {
          e.preventDefault();
        }
      });
    }

    this.initialized = true;
    console.log('Spotify search initialized');  // デバッグ用
  }

  handleKeyDown(event) {
    if (event.key === 'Enter') {
      event.preventDefault();
      event.stopPropagation();
      this.handleSearch();
    }
  }

  handleSearch() {
    const query = this.searchInput.value.trim();
    if (!query) return;

    this.searchResults.innerHTML = '<div class="text-gray-500">検索中...</div>';

    fetch(`/posts/search?query=${encodeURIComponent(query)}`)
      .then(response => {
        if (!response.ok) throw new Error('Search failed');
        return response.json();
      })
      .then(data => this.displayResults(data))
      .catch(error => {
        console.error('Search error:', error);
        this.searchResults.innerHTML = '<div class="text-red-500">検索中にエラーが発生しました</div>';
      });
  }

  displayResults(data) {
    if (!data || data.length === 0) {
      this.searchResults.innerHTML = '<div class="text-gray-500">検索結果が見つかりませんでした</div>';
      return;
    }

    this.searchResults.innerHTML = '';
    
    data.forEach(track => {
      const div = document.createElement('div');
      div.className = 'mb-2';
      div.innerHTML = `
        <button type="button"
                class="bg-transparent border border-blue-500 text-blue-500 text-sm py-1 px-2 rounded-md hover:bg-blue-500 hover:text-white transition duration-300 ease-in-out select-song"
                data-id="${track.id}"
                data-name="${track.name}"
                data-artist="${track.artist}"
                data-album="${track.album}">
          ${track.name} - ${track.artist}
        </button>
      `;
      div.querySelector('button').addEventListener('click', () => this.selectSong(track));
      this.searchResults.appendChild(div);
    });
  }

  selectSong(track) {
    const fields = {
      'post_song_id': track.id,
      'post_song_name': track.name,
      'post_artist_name': track.artist,
      'post_album_name': track.album
    };

    // hidden フィールドに値を設定
    Object.entries(fields).forEach(([id, value]) => {
      const field = document.getElementById(id);
      if (field) field.value = value;
    });

    this.searchResults.innerHTML = `
      <div class="text-green-500">
        選択された曲: ${track.name} - ${track.artist}
      </div>
    `;
  }
}

// Turbo Drive の無効化を確認
if (document.querySelector('form[data-turbo="false"]')) {
  console.log('Turbo is disabled for this form');  // デバッグ用
}

// 初期化関数
function initializeSpotifySearch() {
  new SpotifySearchHandler();
}

// イベントリスナーの設定
document.addEventListener('DOMContentLoaded', initializeSpotifySearch);
document.addEventListener('turbo:load', initializeSpotifySearch);
document.addEventListener('turbo:render', initializeSpotifySearch);
