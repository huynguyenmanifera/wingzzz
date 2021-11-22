import { Controller } from "stimulus";

export default class ProfileSettingsController extends Controller {
  static targets = [
    "template",
    "ageRangeSelector",
    "minAgeInMonths",
    "minAgeInMonthsWrapper",
    "maxAgeInMonths",
    "maxAgeInMonthsWrapper",
    "contentLanguage",
  ];

  open() {
    window.document.body.appendChild(
      this.templateTarget.content.cloneNode(true)
    );
  }

  minAgeInMonthsChange() {
    const values = this.rangeValues();

    if (values.min && values.max && values.max < values.min) {
      this.maxAgeInMonthsTarget.value = values.min;
    }
  }

  maxAgeInMonthsChange() {
    const values = this.rangeValues();

    if (values.min && values.max && values.min > values.max) {
      this.minAgeInMonthsTarget.value = values.max;
    }
  }

  rangeValues() {
    return {
      min: this.minAgeInMonthsTarget.value
        ? parseInt(this.minAgeInMonthsTarget.value)
        : null,
      max: this.maxAgeInMonthsTarget.value
        ? parseInt(this.maxAgeInMonthsTarget.value)
        : null,
    };
  }
}
