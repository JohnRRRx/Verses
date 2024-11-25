import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    this.element.addEventListener("submit", this.closePicker.bind(this));
  }

  closePicker(event) {
    this.toggleTarget.checked = false;
  }
};
