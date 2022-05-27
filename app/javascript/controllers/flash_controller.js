import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {

  static targets = [ "flash", "dismissButton" ]

  connect() {
  }

  dismiss() {
    this.flashTarget.remove();
  }


}
