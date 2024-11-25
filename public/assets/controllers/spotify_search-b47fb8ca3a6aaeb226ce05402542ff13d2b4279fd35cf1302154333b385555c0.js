class SpotifySearchHandler {
  constructor() {
    this.searchInput = document.getElementById('song_search');
    this.searchButton = document.getElementById('search-button');
    this.searchResults = document.getElementById('search-results');
    this.mainForm = document.getElementById('post-form');
    this.songError = document.getElementById('song-error');
    this.cache = new Map();
    this.searchTimer = null;
    this.initialize();
  }

  initialize() {
    if (this.searchInput && this.searchResults) {
      this.setupEventListeners();
      this.searchResults.classList.add('search-results');
    }
  }

  setupEventListeners() {
    this.searchInput.addEventListener('keydown', e => {
      if (e.key === 'Enter') {
        e.preventDefault();
        this.handleSearch();
      }
    });
    this.searchButton?.addEventListener('click', e => {
      e.preventDefault();
      this.handleSearch();
    });
    this.mainForm?.addEventListener('submit', this.handleSubmit.bind(this));
  }

  handleSubmit(e) {
    const songIdField = document.getElementById('post_song_id');
    if (!songIdField?.value) {
      e.preventDefault();
      this.showError('曲を選択してください');
    }
  }

  showError(message) {
    if (this.songError) {
      this.songError.textContent = message;
      this.songError.style.display = 'block';
      this.songError.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }

  handleSearch() {
    clearTimeout(this.searchTimer);
    this.searchTimer = setTimeout(() => {
      const query = this.searchInput.value.trim();
      if (!query) return;

      if (this.cache.has(query)) {
        this.displayResults(this.cache.get(query));
        return;
      }

      this.searchResults.innerHTML = '<div class="search-message search-loading">検索中...</div>';

      fetch(`/posts/search?query=${encodeURIComponent(query)}`)
        .then(response => response.ok ? response.json() : Promise.reject('Search failed'))
        .then(data => {
          this.cache.set(query, data);
          this.displayResults(data);
        })
        .catch(error => {
          console.error('Search error:', error);
          this.searchResults.innerHTML = '<div class="search-message search-error">検索中にエラーが発生しました</div>';
        });
    }, 300);
  }

  displayResults(data) {
    if (!data || data.length === 0) {
      this.searchResults.innerHTML = '<div class="search-message search-not-found">検索結果が見つかりませんでした</div>';
      return;
    }

    this.searchResults.innerHTML = `
      <div class="search-results-scroll">
        ${data.map(track => this.createTrackElement(track)).join('')}
      </div>
    `;

    this.searchResults.querySelectorAll('.search-result-item').forEach((button, index) => {
      button.addEventListener('click', () => this.selectSong(data[index]));
    });
  }

  createTrackElement(track) {
    return `
      <button type="button" class="search-result-item">
        <img src="${this.getAlbumImageUrl(track)}" alt="${track.album || 'Album'} cover" class="album-image">
        <div class="track-info">
          <div class="track-title">${track.name}</div>
          <div class="track-artist">${track.artist}</div>
          <div class="track-album">${track.album || ''}</div>
        </div>
      </button>
    `;
  }

  getAlbumImageUrl(track) {
    return track.album?.images?.length > 0
      ? track.album.images.find(img => img.width <= 64)?.url || track.album.images[0].url
      : track.image_url || '/images/default-album.png';
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
      <div class="selected-track">
        <img src="${this.getAlbumImageUrl(track)}" alt="${track.album || 'Album'} cover" class="album-image">
        <div class="track-info">
          <div class="track-title">選択された曲:</div>
          <div class="track-artist">${track.name} - ${track.artist}</div>
        </div>
      </div>
    `;
  }
}

function initializeSpotifySearch() {
  new SpotifySearchHandler();
}

(function() {
  function initSearch() {
    if (typeof window.initializeSpotifySearch === 'function') {
      window.initializeSpotifySearch();
    } else if (document.getElementById('song_search')) {
      console.warn('initializeSpotifySearch function not found. Retrying...');
      setTimeout(initSearch, 100);
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSearch);
  } else {
    initSearch();
  }

  document.addEventListener('turbo:load', initSearch);
  document.addEventListener('turbo:render', initSearch);
})();

window.initializeSpotifySearch = initializeSpotifySearch;
