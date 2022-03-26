import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-form"
export default class extends Controller {
  submit() {
    document.getElementsByClassName('map-loading')[0].classList.add('visible');
    document.getElementById('mapMenuSubmitButton').click();
  }
}
