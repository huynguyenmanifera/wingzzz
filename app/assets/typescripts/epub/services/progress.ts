import { NavState, next } from "./navigationBehavior";

export type Progress = {
  currentRendition: number;
  totalRenditions: number;
};

export function progress(state: NavState): Progress {
  return {
    currentRendition: currentRendition(state),
    totalRenditions: totalRenditions(state),
  };
}

export function progressRatio(progress: Progress): number {
  if (progress.totalRenditions <= 1) return 1;

  return (progress.currentRendition - 1) / (progress.totalRenditions - 1);
}

function totalRenditions(state: NavState) {
  return renditions(state).length;
}

function currentRendition(state: NavState): number {
  const index = renditions(state).findIndex((currentState: NavState) => {
    const nextState = next(currentState);
    const reachedLastPage = currentState.currentPage === nextState.currentPage;

    return (
      reachedLastPage ||
      (currentState.currentPage <= state.currentPage &&
        state.currentPage < nextState.currentPage)
    );
  });

  return index + 1;
}

function renditions(state: NavState): NavState[] {
  const initialRendition = {
    ...state,
    currentPage: 1,
  };

  const successiveRenditions = (state: NavState): NavState[] => {
    const nextState = next(state);
    return nextState.currentPage !== state.currentPage
      ? [nextState].concat(successiveRenditions(nextState))
      : [];
  };

  return [initialRendition].concat(successiveRenditions(initialRendition));
}
