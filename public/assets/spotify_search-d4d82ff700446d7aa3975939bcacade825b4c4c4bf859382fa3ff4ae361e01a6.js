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

    this.searchResults.className = 'mt-3 border rounded-lg bg-white shadow-lg overflow-hidden mb-20';

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

    this.searchResults.innerHTML = `
      <div class="max-h-[600px] overflow-y-auto">
        <div class="p-2 space-y-2 search-results-container">
        </div>
      </div>
    `;

    const container = this.searchResults.querySelector('.search-results-container');

    data.forEach(track => {
      const div = document.createElement('div');
      div.innerHTML = `
        <button type="button"
                class="w-full text-left px-4 py-3 rounded-lg transition-all duration-200 flex items-center gap-3 hover:bg-blue-50 focus:bg-blue-50 focus:outline-none">
          <div class="flex-shrink-0 w-12 h-12 bg-gray-100 rounded-md overflow-hidden">
            ${track.image_url ? 
              `<img src="${track.image_url}" 
                    alt="${track.album || 'Album'} cover" 
                    class="w-full h-full object-cover">` :
              `<div class="w-full h-full flex items-center justify-center bg-gray-200">
                <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"/>
                </svg>
              </div>`
            }
          </div>
          <div class="flex-grow min-w-0">
            <div class="font-medium text-gray-900 truncate">${track.name}</div>
            <div class="text-sm text-gray-500 truncate">${track.artist}</div>
            <div class="text-xs text-gray-400 truncate">${track.album || ''}</div>
          </div>
        </button>
      `;

      const button = div.querySelector('button');
      button.addEventListener('click', () => this.selectSong(track));
      container.appendChild(div);
    });
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
          <div class="flex-shrink-0 w-12 h-12 bg-gray-100 rounded-md overflow-hidden">
            ${track.image_url ? 
              `<img src="${track.image_url}" 
                    alt="${track.album || 'Album'} cover" 
                    class="w-full h-full object-cover">` :
              `<div class="w-full h-full flex items-center justify-center bg-gray-200">
                <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"/>
                </svg>
              </div>`
            }
          </div>
          <div>
            <div class="font-medium">選択された曲:</div>
            <div class="text-sm">${track.name} - ${track.artist}</div>
          </div>
        </div>
      </div>
    `;
  }
}

// 初期化
function initializeSpotifySearch() {
  new SpotifySearchHandler();
}

document.addEventListener('DOMContentLoaded', initializeSpotifySearch);
document.addEventListener('turbo:load', initializeSpotifySearch);
document.addEventListener('turbo:render', initializeSpotifySearch);
