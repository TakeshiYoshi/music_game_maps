import { Controller } from "@hotwired/stimulus"
import MapIconGrayImage from '../../images/map_icon_gray.png';

// Connects to data-controller="map"
export default class extends Controller {
  initialize() {
    window.globalFunction.rePutMapIcons(JSON.parse(this.element.dataset.shopsData));

    Array.from(document.getElementsByClassName('m-shopCard')).map((shop) => {
      const isClosed = shop.getElementsByClassName('m-shopCard__label').length === 0;

      if (isClosed && document.getElementById(shop.dataset.targetMarker).length !== 0) {
        document.getElementById(shop.dataset.targetMarker).src = MapIconGrayImage;
      }
    })
  }
}
