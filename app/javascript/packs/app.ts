import * as React from "react";
import * as ReactDOM from "react-dom";
import ReactContext from "./ReactContext";
import I18n from "i18n-js";
import "controllers";

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

let _window: any = window;

let reactContext = new ReactContext();

document.addEventListener(
  "turbolinks:before-render",
  reactContext.unmountComponents
);

_window.dataLayer = _window.dataLayer || [];

document.addEventListener("turbolinks:load", function (event: any) {
  _window.dataLayer.push({ event: "pageView", virtualUrl: event.data.url });
});

const getMetaElement = (name: string): string => {
  const selector = `meta[name=${name}]`;
  const element: HTMLMetaElement | null = document.querySelector(selector);
  if (!element) {
    throw new Error(`Could not find meta element ${selector}`);
  }
  return element.content;
};

I18n.locale = getMetaElement("locale");
I18n.translations = Object.keys(_window.translations).reduce(
  (acc: any, language: any) => {
    acc[language] = _window.translations[language]["front"];
    return acc;
  },
  {}
);

_window.renderComponent = reactContext.renderComponent;

_window.csrfToken = getMetaElement("csrf-token");
