// グローバルスコープで初期化状態を管理
let isInitialized = false;

function initializeSongSearch() {
  // 既に初期化されている場合は早期リターン
  if (isInitialized) {
    return;
  }

  const searchButton = document.getElementById('search-button');
  const songSearch = document.getElementById('song_search');
  const searchResults = document.getElementById('search-results');
  const form = document.querySelector('form');

  if (!songSearch || !searchResults) {
    return; // 必要な要素が存在しない場合は初期化しない
  }

  // 検索ボタンのクリックイベント
  if (searchButton) {
    searchButton.addEventListener('click', function(event) {
      event.preventDefault();
      performSearch(songSearch.value, searchResults);
    });
  }

  // Enterキーのイベントハンドラー
  function handleEnterKey(event) {
    if (event.key === 'Enter') {
      event.preventDefault(); // フォームのデフォルトの送信を防ぐ
      performSearch(songSearch.value, searchResults);
    }
  }

  // フォーム全体にイベントリスナーを追加
  if (form) {
    form.addEventListener('keydown', function(event) {
      if (event.target.id === 'song_search') {
        handleEnterKey(event);
      }
    });
  }

  // 検索入力欄自体にもイベントリスナーを追加
  songSearch.addEventListener('keydown', handleEnterKey);

  isInitialized = true;
}

// 検索処理を行う関数
function performSearch(query, searchResults) {
  if (!query.trim()) return; // 空文字列での検索を防ぐ

  fetch(`/posts/search?query=${encodeURIComponent(query)}`)
    .then(response => response.json())
    .then(data => {
      searchResults.innerHTML = '';
      data.forEach(track => {
        const div = document.createElement('div');
        div.className = 'mb-2';
        div.innerHTML = `
          <button type="button" class="bg-transparent border border-blue-500 text-blue-500 text-sm py-1 px-2 rounded-md hover:bg-blue-500 hover:text-white transition duration-300 ease-in-out select-song"
                  data-id="${track.id}"
                  data-name="${track.name}"
                  data-artist="${track.artist}"
                  data-album="${track.album}">
            ${track.name} - ${track.artist}
          </button>
        `;
        searchResults.appendChild(div);
      });

      // 曲選択ボタンのイベントリスナー
      document.querySelectorAll('.select-song').forEach(button => {
        button.addEventListener('click', function() {
          document.getElementById('post_song_id').value = this.dataset.id;
          document.getElementById('post_song_name').value = this.dataset.name;
          document.getElementById('post_artist_name').value = this.dataset.artist;
          document.getElementById('post_album_name').value = this.dataset.album;
          searchResults.innerHTML = `選択された曲: ${this.dataset.name} - ${this.dataset.artist}`;
        });
      });
    })
    .catch(error => {
      console.error('検索エラー:', error);
      searchResults.innerHTML = '<div class="text-red-500">検索中にエラーが発生しました。</div>';
    });
}

// イベントリスナーの設定
document.addEventListener('turbo:load', initializeSongSearch);
document.addEventListener('turbo:render', initializeSongSearch);
document.addEventListener('DOMContentLoaded', initializeSongSearch);

// 削除ボタンの確認ダイアログ
function initializeDeleteButtons() {
  const deleteButtons = document.querySelectorAll('[data-confirm]');

  deleteButtons.forEach(button => {
    button.addEventListener('click', function(event) {
      const confirmationMessage = this.getAttribute('data-confirm');
      if (!confirm(confirmationMessage)) {
        event.preventDefault();
      }
    });
  });
}

document.addEventListener('turbo:load', initializeDeleteButtons);
document.addEventListener('turbo:render', initializeDeleteButtons);
