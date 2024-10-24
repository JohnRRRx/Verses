import "@hotwired/turbo-rails"
import "./controllers"
import './spotify_search'

document.addEventListener("turbo:load", () => {
    console.log("Turbo is loaded!");
  });
