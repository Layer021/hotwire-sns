import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // フェードイン
    setTimeout(() => {
      this.element.classList.remove("opacity-0");
    }, 100);

    // 3秒後にフェードアウトして削除
    setTimeout(() => {
      this.element.classList.add("opacity-0");
      setTimeout(() => this.element.remove(), 500);
    }, 3000);
  }
}
