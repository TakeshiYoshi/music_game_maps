import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  initialize() {
    window.globalFunction.rePutMapIcons(JSON.parse(this.element.dataset.shopsData));
  }
}
