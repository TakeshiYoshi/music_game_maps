import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-top"
export default class extends Controller {
  initialize() {
    if (document.getElementsByClassName('m-scrollTop').length !== 0) {
      window.addEventListener("scroll", this.handleScroll);
    }
  }

  scrollTop() {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  }

  handleScroll() {
    const thisNode = document.getElementsByClassName('m-scrollTop')[0];
    let html = window.document.documentElement;
    let scrollBottomY = html.scrollHeight - html.clientHeight - window.scrollY;

    if (window.scrollY > 200 && scrollBottomY > 60) {
      thisNode.classList.add('visible')
    } else {
      thisNode.classList.remove('visible')
    }
  }
}
