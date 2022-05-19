import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="embedded-tweet"
export default class extends Controller {

  static targets = ['container', 'loadingContainer']
  static values = {
    username: String,
    id: String,
    url: String
  }

  connect() {
    let loadingContainer = this.loadingContainerTarget
    
    window.twttr.widgets.createTweet(
      this.idValue,
      document.getElementById(this.idValue),
      {
        conversation: 'none',
        cards: 'hidden'
      }
    ).then(function (_el) {
      loadingContainer.classList.add('hidden')
    });
  }
}
