class SpotifySearchHandler {
  constructor() {
    this.searchInput = document.getElementById('song_search');
    this.searchButton = document.getElementById('search-button');
    this.searchResults = document.getElementById('search-results');
    this.mainForm = document.getElementById('post-form');
    this.songError = document.getElementById('song-error');
    this.submitButton = document.querySelector('input[type="submit"]');
    this.initialized = false;

    if (this.searchInput && this.searchResults) {
      this.initialize();
    }
  }

  initialize() {
    if (this.initialized) return;

    // 検索結果コンテナのベーススタイル
    this.searchResults.style.cssText = `
      margin-top: 1rem;
      margin-bottom: 5rem;
      border: 1px solid #e5e7eb;
      border-radius: 0.5rem;
      background-color: white;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    `;

    this.searchInput.addEventListener('keydown', this.handleKeyDown.bind(this));

    if (this.searchButton) {
      this.searchButton.addEventListener('click', (e) => {
        e.preventDefault();
        this.handleSearch();
      });
    }

    if (this.mainForm) {
      this.mainForm.addEventListener('submit', this.handleSubmit.bind(this));
    }

    // スタイルシートの追加
    this.addStyles();

    this.initialized = true;
  }

  addStyles() {
    const style = document.createElement('style');
    style.textContent = `
      .search-results-scroll {
        max-height: 600px;
        overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: #cbd5e1 transparent;
      }
      .search-results-scroll::-webkit-scrollbar {
        width: 6px;
      }
      .search-results-scroll::-webkit-scrollbar-track {
        background: transparent;
      }
      .search-results-scroll::-webkit-scrollbar-thumb {
        background-color: #cbd5e1;
        border-radius: 3px;
      }
      .search-result-item {
        padding: 0.75rem 1rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        border-radius: 0.5rem;
        transition: background-color 0.2s ease;
        cursor: pointer;
        width: 100%;
        text-align: left;
      }
      .search-result-item:hover {
        background-color: #eff6ff;
      }
      .album-image {
        width: 48px;
        height: 48px;
        border-radius: 0.375rem;
        object-fit: cover;
      }
    `;
    document.head.appendChild(style);
  }

  handleKeyDown(event) {
    if (event.key === 'Enter') {
      event.preventDefault();
      event.stopPropagation();
      this.handleSearch();
    }
  }

  handleSubmit(e) {
    const songIdField = document.getElementById('post_song_id');
    if (!songIdField || !songIdField.value) {
      e.preventDefault();
      if (this.songError) {
        this.songError.style.display = 'block';
        this.songError.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    } else if (this.songError) {
      this.songError.style.display = 'none';
    }
  }

  handleSearch() {
    const query = this.searchInput.value.trim();
    if (!query) return;

    this.searchResults.innerHTML = `
      <div style="padding: 1rem; text-align: center; color: #6b7280;">
        <div style="display: inline-block; width: 1.5rem; height: 1.5rem; border: 2px solid #e5e7eb; border-top-color: #3b82f6; border-radius: 50%; animation: spin 1s linear infinite;"></div>
        <div style="margin-top: 0.5rem;">検索中...</div>
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
          <div style="padding: 1rem; text-align: center; color: #ef4444;">
            <div style="margin-bottom: 0.5rem;">⚠️</div>
            <div>検索中にエラーが発生しました</div>
          </div>
        `;
      });
  }

  displayResults(data) {
    if (!data || data.length === 0) {
      this.searchResults.innerHTML = `
        <div style="padding: 1rem; text-align: center; color: #6b7280;">
          <div style="margin-bottom: 0.5rem;">🔍</div>
          <div>検索結果が見つかりませんでした</div>
        </div>
      `;
      return;
    }

    this.searchResults.innerHTML = `
      <div class="search-results-scroll">
        <div style="padding: 0.5rem;">
          ${data.map(track => `
            <button type="button" class="search-result-item">
              <img src="${this.getAlbumImageUrl(track)}" 
                   alt="${track.album || 'Album'} cover" 
                   class="album-image">
              <div style="min-width: 0; flex-grow: 1;">
                <div style="font-weight: 500; color: #111827; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                  ${track.name}
                </div>
                <div style="font-size: 0.875rem; color: #6b7280; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                  ${track.artist}
                </div>
                <div style="font-size: 0.75rem; color: #9ca3af; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                  ${track.album || ''}
                </div>
              </div>
            </button>
          `).join('')}
        </div>
      </div>
    `;

    // イベントリスナーの追加
    const buttons = this.searchResults.getElementsByClassName('search-result-item');
    Array.from(buttons).forEach((button, index) => {
      button.addEventListener('click', () => this.selectSong(data[index]));
    });
  }

  getAlbumImageUrl(track) {
    if (track.album?.images?.length > 0) {
      const image = track.album.images.find(img => img.width <= 64) || track.album.images[0];
      return image.url;
    }
    return track.image_url || '/images/default-album.png';
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

    if (this.songError) {
      this.songError.style.display = 'none';
    }

    this.searchResults.innerHTML = `
      <div style="padding: 1rem;">
        <div style="background-color: #f0fdf4; color: #166534; padding: 1rem; border-radius: 0.5rem; display: flex; align-items: center; gap: 0.75rem;">
          <img src="${this.getAlbumImageUrl(track)}"
               alt="${track.album || 'Album'} cover"
               class="album-image">
          <div>
            <div style="font-weight: 500;">選択された曲:</div>
            <div style="font-size: 0.875rem;">${track.name} - ${track.artist}</div>
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
