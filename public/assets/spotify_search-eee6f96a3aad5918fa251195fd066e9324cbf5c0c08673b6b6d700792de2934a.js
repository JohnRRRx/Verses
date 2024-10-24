function initializeSongSearch() {
  const searchButton = document.getElementById('search-button');
  const songSearch = document.getElementById('song_search');
  const searchResults = document.getElementById('search-results');

  if (searchButton) {
    searchButton.addEventListener('click', function() {
      const query = songSearch.value;
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

          document.querySelectorAll('.select-song').forEach(button => {
            button.addEventListener('click', function() {
              document.getElementById('post_song_id').value = this.dataset.id;
              document.getElementById('post_song_name').value = this.dataset.name;
              document.getElementById('post_artist_name').value = this.dataset.artist;
              document.getElementById('post_album_name').value = this.dataset.album;
              searchResults.innerHTML = `選択された曲: ${this.dataset.name} - ${this.dataset.artist}`;
            });
          });
        });
    });
  }
}

// turbo:load と DOMContentLoaded の両方で初期化
document.addEventListener('turbo:load', initializeSongSearch);
document.addEventListener('DOMContentLoaded', initializeSongSearch);

document.addEventListener('turbo:load', () => {
  const deleteButtons = document.querySelectorAll('[data-confirm]');

  deleteButtons.forEach(button => {
    button.addEventListener('click', function(event) {
      const confirmationMessage = this.getAttribute('data-confirm');
      if (!confirm(confirmationMessage)) {
        event.preventDefault(); // キャンセル時に削除をキャンセル
      }
    });
  });
});
