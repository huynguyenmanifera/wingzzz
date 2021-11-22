import * as React from "react";
import Icon from "../../ui/Icon";

export default class TopToolbar extends React.PureComponent {
  render() {
    return (
      <div className={"fbook-top-toolbar"}>
        <a href="/books" data-action="exit">
          <Icon type="back" size="large" />
        </a>
      </div>
    );
  }
}
