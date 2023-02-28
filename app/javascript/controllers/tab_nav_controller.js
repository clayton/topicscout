import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab-nav"
export default class extends Controller {

  static targets = [ "form" ]

  static values = {
    tweets: String,
    urls: String,
    saves: String
  }  

  connect() {
  }

  navigate(event) {
    const target = event.target
    const value = target.selectedOptions[0].value
    
    switch (value) {
      case "tweets":
        this.formTarget.action = this.tweetsValue
        break
      case "urls":
        this.formTarget.action = this.urlsValue
        break
      case "saves":
        this.formTarget.action = this.savesValue
        break
      default:
        break
    }

    this.formTarget.submit()

  }
}
