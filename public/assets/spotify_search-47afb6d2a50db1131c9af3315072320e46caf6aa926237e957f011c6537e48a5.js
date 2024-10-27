class SpotifySearchHandler {
  constructor() {
    this.searchInput = document.getElementById('song_search');
    this.searchButton = document.getElementById('search-button');
    this.searchResults = document.getElementById('search-results');
    this.mainForm = this.searchInput?.closest('form');
    this.initialized = false;

    if (this.searchInput && this.searchResults) {
      this.initialize();
    }
  }

  initialize() {
    if (this.initialized) return;

    // 検索結果コンテナのスタイリング
    this.searchResults.className = 'mt-3 border rounded-lg bg-white shadow-sm overflow-hidden';
    
    this.searchInput.addEventListener('keydown', this.handleKeyDown.bind(this));

    if (this.searchButton) {
      this.searchButton.addEventListener('click', (e) => {
        e.preventDefault();
        this.handleSearch();
      });
    }

    if (this.mainForm) {
      this.mainForm.addEventListener('submit', (e) => {
        const activeElement = document.activeElement;
        if (activeElement === this.searchInput) {
          e.preventDefault();
        }
      });
    }

    this.initialized = true;
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

    // 検索中の表示をスタイリング
    this.searchResults.innerHTML = `
      <div class="p-4 text-gray-500 text-center">
        <div class="animate-spin inline-block w-6 h-6 border-2 border-gray-300 border-t-blue-500 rounded-full mb-2"></div>
        <div>検索中...</div>
      </div>
    `;

    fetch(`/posts/search?query=${encodeURIComponent(query)}`)
      .then(response => {
        if (!response.ok) throw new Error('Search failed');
        return response.json();
      })
      .then(data => this.displayResults(data))
      .catch(error => {
        console.error('Search error:', error);
        this.searchResults.innerHTML = `
          <div class="p-4 text-red-500 text-center">
            <div class="mb-2">⚠️</div>
            <div>検索中にエラーが発生しました</div>
          </div>
        `;
      });
  }

  displayResults(data) {
    if (!data || data.length === 0) {
      this.searchResults.innerHTML = `
        <div class="p-4 text-gray-500 text-center">
          <div class="mb-2">🔍</div>
          <div>検索結果が見つかりませんでした</div>
        </div>
      `;
      return;
    }

    // 検索結果コンテナのスタイリング
    this.searchResults.innerHTML = `
      <div class="max-h-60 overflow-y-auto">
        <div class="p-2 space-y-2 search-results-container">
        </div>
      </div>
    `;

    const container = this.searchResults.querySelector('.search-results-container');
    
    data.forEach(track => {
      const div = document.createElement('div');
      div.innerHTML = `
        <button type="button"
                class="w-full text-left px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors duration-200 flex items-center gap-3 group">
          <div class="flex-shrink-0 w-10 h-10 bg-gray-100 rounded-md flex items-center justify-center group-hover:bg-gray-200 transition-colors duration-200">
            🎵
          </div>
          <div class="flex-grow min-w-0">
            <div class="font-medium text-gray-900 truncate">${track.name}</div>
            <div class="text-sm text-gray-500 truncate">${track.artist}</div>
          </div>
          <div class="flex-shrink-0 text-blue-500 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
            選択 →
          </div>
        </button>
      `;

      const button = div.querySelector('button');
      button.addEventListener('click', () => this.selectSong(track));
      container.appendChild(div);
    });

    // 下部の余白を確保
    this.searchResults.style.marginBottom = '2rem';
  }

  selectSong(track) {
    const fields = {
      'post_song_id': track.id,
      'post_song_name': track.name,
      'post_artist_name': track.artist,
      'post_album_name': track.album
    };

    Object.entries(fields).forEach(([id, value]) => {
      const field = document.getElementById(id);
      if (field) field.value = value;
    });

    this.searchResults.innerHTML = `
      <div class="p-4">
        <div class="bg-green-50 text-green-700 p-4 rounded-lg flex items-center gap-3">
          <div class="flex-shrink-0 w-10 h-10 bg-green-100 rounded-md flex items-center justify-center">
            ✓
          </div>
          <div>
            <div class="font-medium">選択された曲:</div>
            <div class="text-sm">${track.name} - ${track.artist}</div>
          </div>
        </div>
      </div>
    `;

    // 選択後の余白を適切に設定
    this.searchResults.style.marginBottom = '2rem';
  }
}

// 初期化
function initializeSpotifySearch() {
  new SpotifySearchHandler();
}

document.addEventListener('DOMContentLoaded', initializeSpotifySearch);
document.addEventListener('turbo:load', initializeSpotifySearch);
document.addEventListener('turbo:render', initializeSpotifySearch);
