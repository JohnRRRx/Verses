document.addEventListener('DOMContentLoaded', () => {
    const fileInput = document.querySelector('.file-input');
    const filenameDisplay = document.getElementById('filename');
  
    if (fileInput && filenameDisplay) {
      fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
          filenameDisplay.textContent = e.target.files[0].name;
        } else {
          filenameDisplay.textContent = 'ファイルが選択されていません';
        }
      });
    }
  });
