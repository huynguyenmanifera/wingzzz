import * as React from "react";
import PageNavigationArea, { Type } from "./PageNavigateArea";
import PageNavigationButton, { ButtonType } from "./NavigateButton";

interface PageNavigationAreasProps {
  canNavigatePrevious: boolean;
  onNavigatePrevious: () => void;
  canNavigateNext: boolean;
  onNavigateNext: () => void;
}

export default class PageNavigationAreas extends React.PureComponent<PageNavigationAreasProps> {
  render() {
    return (
      <>
        {this.props.canNavigatePrevious && (
          <PageNavigationArea
            active={this.props.canNavigatePrevious}
            type={Type.Previous}
            onClick={this.props.onNavigatePrevious}
          />
        )}
        {this.props.canNavigateNext && (
          <PageNavigationArea
            active={this.props.canNavigateNext}
            type={Type.Next}
            onClick={this.props.onNavigateNext}
          />
        )}
      </>
    );
  }
}
