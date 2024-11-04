(function() {
    function initSearch() {
      if (typeof window.initializeSpotifySearch === 'function') {
        window.initializeSpotifySearch();
      } else if (document.getElementById('song_search')) {
        // Spotify検索要素が存在する場合のみ再試行
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
