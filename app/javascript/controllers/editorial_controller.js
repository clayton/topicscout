import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="editorial"
export default class extends Controller {

  static targets = [ "form", "button" ]

  connect() {
  }

  save(event) {
    // event.preventDefault()
    // this.buttonTarget.disabled = true
    // this.buttonTarget.innerHTML = "Saving..."
    
    // this.formTarget.submit()
  }
}
