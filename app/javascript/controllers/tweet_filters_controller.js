import { Controller } from "@hotwired/stimulus";
import { enter, leave } from "el-transition";

// Connects to data-controller="tweet-filters"
export default class extends Controller {
  static targets = [
    "sort",
    "mobileDialog",
    "offCanvasMenu",
    "offCanvasMenuBackdrop",
    "timingExpander",
    "desktopTimingFilter",
    "timingForm",
    "visibilityForm",
    "desktopVisibilityFilter",
  ];

  connect() {}

  toggleSort() {
    if (this.sortTarget.classList.contains("hidden")) {
      enter(this.sortTarget);
    } else {
      leave(this.sortTarget);
    }
  }

  toggleMobileDialog() {
    if (this.mobileDialogTarget.classList.contains("hidden")) {
      enter(this.mobileDialogTarget);
      enter(this.offCanvasMenuTarget);
      enter(this.offCanvasMenuBackdropTarget);
    } else {
      leave(this.offCanvasMenuBackdropTarget);
      leave(this.offCanvasMenuTarget);
      leave(this.mobileDialogTarget);
    }
  }

  toggleTimingFilter() {
    if (this.timingExpanderTarget.classList.contains("rotate-0")) {
      this.timingExpanderTarget.classList.remove("rotate-0");
      this.timingExpanderTarget.classList.add("rotate-180");
    } else {
      this.timingExpanderTarget.classList.remove("rotate-180");
      this.timingExpanderTarget.classList.add("rotate-0");
    }
  }

  toggleDesktopTimingFilter() {
    if (this.desktopTimingFilterTarget.classList.contains("hidden")) {
      enter(this.desktopTimingFilterTarget);
    } else {
      leave(this.desktopTimingFilterTarget);
    }
  }

  toggleDesktopVisibilityFilter() {
    if (this.desktopVisibilityFilterTarget.classList.contains("hidden")) {
      enter(this.desktopVisibilityFilterTarget);
    } else {
      leave(this.desktopVisibilityFilterTarget);
    }
  }

  changeTimingFilter(event) {
    this.timingFormTarget.submit();
  }

  changeVisibilityFilter(event) {
    this.visibilityFormTarget.submit();
  }
}
