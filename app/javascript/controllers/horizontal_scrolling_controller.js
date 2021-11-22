import { Controller } from "stimulus";
import * as _ from "lodash";

export default class extends Controller {
  static targets = ["list", "forward", "backward"];

  connect() {
    this.updateScrollButtons = _.throttle(this._updateScrollButtons, 500).bind(
      this
    );
    this.updateScrollButtons();
  }

  goForward(e) {
    e.preventDefault();
    this.scroll("forward");
  }

  goBackward(e) {
    e.preventDefault();
    this.scroll("backward");
  }

  scroll(direction) {
    let left = this.listTarget.scrollLeft;

    if (direction === "forward") {
      left += this.scrollValue;
    } else {
      left -= this.scrollValue;
    }

    this.listTarget.scrollTo({ left: left, behavior: "smooth" });
    this.updateScrollButtons();
  }

  _updateScrollButtons() {
    this.backwardTarget.style.display = this.isAtStart ? "none" : "flex";
    this.forwardTarget.style.display = this.isAtEnd ? "none" : "flex";
  }

  get scrollValue() {
    const times = 2;
    const width = this.listTarget.querySelector("li").offsetWidth;

    return times * width;
  }

  get isAtStart() {
    return this.listTarget.scrollLeft === 0;
  }

  get isAtEnd() {
    return (
      this.listTarget.scrollLeft + this.listTarget.clientWidth >=
      this.listTarget.scrollWidth
    );
  }
}
