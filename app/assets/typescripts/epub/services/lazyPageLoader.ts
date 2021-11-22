enum FlipEventType {
  "next",
  "prev",
  "slide",
  "restart",
  "user_fold",
  "flipping",
}

export function lazyLoader(
  pnum: number,
  flipEvent: FlipEventType,
  bookDb: Array<any>,
  currentPage: number
) {
  const isEven = pnum % 2 === 0;
  const isForward = currentPage < pnum;
  let isOneStep = currentPage - pnum === 2 || currentPage - pnum === -2;
  if (currentPage % 2 === 0) {
    isOneStep = currentPage - pnum === 3 || currentPage - pnum === -1;
  }

  let from: number = 0;
  let to: number = 0;

  if (isOneStep) {
    isForward ? (flipEvent = FlipEventType.next) : FlipEventType.prev;
  }

  switch (flipEvent) {
    case FlipEventType.next:
      from = isEven ? pnum + 1 : pnum + 2;
      to = isEven ? pnum + 3 : pnum + 4;
      break;
    case FlipEventType.prev:
      from = isEven ? pnum - 3 : pnum - 3;
      to = isEven ? pnum - 1 : pnum;
      break;
    case FlipEventType.restart:
      from = 0;
      to = 3;
      break;
    case FlipEventType.slide:
      from = isEven ? pnum - 3 : pnum - 2;
      to = isEven ? pnum + 3 : pnum + 4;
      break;
  }

  if (from < 0) {
    from = 0;
  }

  if (to > bookDb.length) {
    to = bookDb.length;
  }

  let pagesToLoad = bookDb.slice(from, to);

  if (!isForward) {
    pagesToLoad = pagesToLoad.reverse();
  }

  pagesToLoad.forEach((page: any, idx: number) => {
    if (!page.loaded) {
      loadPage(page, bookDb);
    }
  });

  return pagesToLoad;
}

export function imageLoader(page: any, epubDir: String) {
  const image = new Image();
  const imgUrl = epubDir + page["href"];
  page.needed = true;
  return new Promise((resolve) => {
    image.onload = () => {
      if (image.complete) {
        page.loaded = true;
        resolve(image);
      }
    };
    image.src = imgUrl;
  });
}

export function loadPage(page: any, bookDb: Array<any>) {
  if (bookDb[page.page].lazyRef.current) {
    bookDb[page.page].lazyRef.current.loadImage();
  }
}
