import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-loader"
export default class extends Controller {
  connect() {
  }

  display() {
    document.getElementsByClassName('map-loading')[0].classList.add('visible');
  }
}
