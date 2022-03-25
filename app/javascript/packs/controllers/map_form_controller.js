import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-form"
export default class extends Controller {
  submit() {
    document.getElementById('mapMenuSubmitButton').click();
  }
}
