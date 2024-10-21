import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  performSearch(event) {
    event.preventDefault();
    const query = this.inputTarget.value;

    if (query.trim() === "") {
      alert("キーワードを入力してください");
      return;
    }

    fetch(`/music/search?song=${encodeURIComponent(query)}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" },
    })
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html;
      });
  }
};
