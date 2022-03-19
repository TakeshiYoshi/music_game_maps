import { Controller } from "stimulus"

export default class extends Controller {
  initialize() {
    // メッセージがない場合は表示しない
    if (this.element.innerHTML === '') {
      return false
    }

    // フェードインアニメーション
    this.element.classList.add('display');
    // 5秒でフェードアウトアニメーション
    setTimeout(() => {
      this.element.classList.remove('display');
    }, 5000);
  }
}
