import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="saved-hashtag"
export default class extends Controller {

  static targets = [ "forms" ]

  connect() {
  }

  close(event) {
    event.preventDefault()
    this.formsTarget.classList.add('hidden')
  }

  open(event) {
    event.preventDefault()
    this.formsTarget.classList.remove('hidden')
  }
}
