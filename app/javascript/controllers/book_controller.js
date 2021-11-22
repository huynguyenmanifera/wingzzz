import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["template"];

  open() {
    window.document.body.appendChild(
      this.templateTarget.content.cloneNode(true)
    );
  }
}
