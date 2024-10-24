import "@hotwired/turbo-rails"
import "./controllers"
import './spotify_search'

document.addEventListener("turbo:load", () => {
    // Turboの動作状態をチェック
    console.log("Turbo状態チェック:", {
      turboPresent: typeof Turbo !== 'undefined',
      sessionPresent: typeof Turbo?.session !== 'undefined',
      navigationEnabled: Turbo?.navigator?.started,
      cacheEnabled: typeof Turbo?.cache !== 'undefined'
    });
  });