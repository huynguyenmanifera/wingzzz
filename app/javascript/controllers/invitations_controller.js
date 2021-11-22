import { Controller } from "stimulus";

export default class ProfileSettingsController extends Controller {
  static targets = ["template"];

  open() {
    window.document.body.appendChild(
      this.templateTarget.content.cloneNode(true)
    );
  }
}
