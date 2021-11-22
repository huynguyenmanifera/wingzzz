import * as React from "react";
import * as ReactDOM from "react-dom";
const exposedComponents = require("./exposed_components").default;

let mountedElements: HTMLElement[] = [];

export default class ReactContext {
  renderComponent(component: string, id: string, props: {}) {
    const componentClass: React.ComponentClass = exposedComponents[component];

    if (!componentClass) {
      throw `Component '${component}' does not exist, or is not registered as an exposed component in exposed_components.tsx.`;
    }

    let element = document.getElementById(id);
    if (!element) {
      throw `Couldn't find element with id '${id}'`;
    }

    ReactDOM.render(React.createElement(componentClass, props), element);

    mountedElements.push(element);
  }

  unmountComponents() {
    mountedElements.forEach(ReactDOM.unmountComponentAtNode);
    mountedElements = [];
  }
}
