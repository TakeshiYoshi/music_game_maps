import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-menu"
export default class extends Controller {
  connect() {
    this.buttonNode = document.getElementsByClassName('m-userMenu__button')[0];
    this.listsNode = document.getElementsByClassName('m-userMenu__list-item');
  }

  toggle() {
    if (this.buttonNode.classList.contains('opened') === true) {
      this.buttonNode.classList.remove('opened');
      Array.from(this.listsNode).map((list) => {
        list.classList.remove('opened');
        list.classList.remove('opened-animation');
      });
    } else {
      this.buttonNode.classList.add('opened');
      Array.from(this.listsNode).map((list) => {
        list.classList.add('opened');
      });
      setTimeout(() => {
        Array.from(this.listsNode).map((list) => {
          list.classList.add('opened-animation');
        });
      }, 100);
    }
  }
}
