import {
  Rendition,
  NavState,
  rendition,
  next,
  previous,
} from "./navigationBehavior";
import * as _ from "lodash";
import { Layout } from "../Book";

export function renditionKey(rendition: Rendition) {
  switch (rendition.layout) {
    case Layout.SinglePage:
      return `${rendition.page}`;

    case Layout.TwoPages:
      return `${rendition.leftPage}:${rendition.rightPage}`;
  }
}

export function renditionsBefore(state: NavState) {
  return (amount: number): Rendition[] => {
    return _.range(0, amount)
      .reduce((states: NavState[]) => {
        const lastState = _.head(states) || state;
        const prevState = previous(lastState);
        return lastState.currentPage === prevState.currentPage
          ? states
          : [prevState].concat(states);
      }, [])
      .map(rendition);
  };
}

export function renditionsAhead(state: NavState) {
  return (amount: number): Rendition[] => {
    return _.range(0, amount)
      .reduce((states: NavState[]) => {
        const lastState = _.last(states) || state;
        const nextState = next(lastState);
        return lastState.currentPage === nextState.currentPage
          ? states
          : states.concat([nextState]);
      }, [])
      .map(rendition);
  };
}
