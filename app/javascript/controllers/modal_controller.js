import { Controller } from "stimulus";

export default class ModalController extends Controller {
  static keyDownEvent = "keydown";

  initialize() {
    this.onKeyDown = this._onKeyDown.bind(this);
  }

  connect() {
    document.addEventListener(ModalController.keyDownEvent, this.onKeyDown);
  }

  disconnect() {
    document.removeEventListener(ModalController.keyDownEvent, this.onKeyDown);
  }

  close() {
    this.element.remove();
  }

  _onKeyDown(e) {
    if (/^Esc/.test(e.key)) {
      this.close();
    }
  }
}
