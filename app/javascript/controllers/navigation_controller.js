import { Controller } from "@hotwired/stimulus"
import { toggle } from "el-transition"

// Connects to data-controller="navigation"
export default class extends Controller {

  static targets = ['offCanvasBackdrop', 'mobileMenu', 'offCanvasMenu', 'closeButton']

  connect() {
  }

  toggle() {
    toggle(this.offCanvasBackdropTarget)
    toggle(this.mobileMenuTarget)
    toggle(this.offCanvasMenuTarget)
    toggle(this.closeButtonTarget)
    
  }
}
