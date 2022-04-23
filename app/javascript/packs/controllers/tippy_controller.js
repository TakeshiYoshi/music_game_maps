import { Controller } from "@hotwired/stimulus"
import tippy from "tippy.js"

// Connects to data-controller="shared--tippy"
export default class extends Controller {
  static values = { content: String };

  connect() {
    tippy(this.element, {
      content: this.contentValue,
      trigger: 'mouseenter',
    });
  }
}
