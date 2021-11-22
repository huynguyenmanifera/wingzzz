import { AnalyticsEvent } from "./Analytics";

export type UpdateBookSessionParams = {
  currentPage: number;
};

const updateBookSession = (config: {
  bookSessionURL: string;
  csrfToken: string;
}) => {
  return (params: UpdateBookSessionParams, analytics?: AnalyticsEvent) => {
    return fetch(config.bookSessionURL, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": config.csrfToken,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({
        book_session: {
          current_page: params.currentPage,
        },
        analytics_event: analytics
          ? {
              ...analytics,
            }
          : undefined,
      }),
    });
  };
};

export default updateBookSession;
