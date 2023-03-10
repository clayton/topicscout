import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="similar-url"
export default class extends Controller {

  static values = {
    path: String
  }

  connect() {
    this.load()
  }

  load() {
    fetch(this.pathValue)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
