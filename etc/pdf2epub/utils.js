const path = require("path");

module.exports.replaceExt = function (filePath, ext) {
  return path.basename(filePath, path.extname(filePath)) + `.${ext}`;
};

/**
 * Sends an event over the SSE stream.
 * On the frontend can be subscribed to using:
 *
 * const eventSource = new EventSource("/jobs/:jobId/status");
 *
 * eventSource.addEventListener("eventName", function(e) {
 *   console.log(e.data);
 * });
 */
module.exports.sendSSEvent = function (res, eventName, data) {
  res.write(`event: ${eventName}\n`);
  res.write(`data: ${JSON.stringify(data)}\n\n`);
};

/**
 * Start SSE stream.
 */
module.exports.startSSE = function (res) {
  res.writeHead(200, {
    "Content-Type": "text/event-stream",
    "Cache-Control": "no-cache",
    Connection: "keep-alive",
  });

  res.write("\n");
};
