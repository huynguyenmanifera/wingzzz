# EPUB Reader

The EPUB reader is a React application that enables the user to view eBooks in EPUB format. The displaying of
individual pages is handled by Epub.js, which loads the content in an iframe under the hood.

## Renditions

Depending on the content, sometimes we want to show two pages side by side. If we are showing page 2 and 3,
then pressing next should result in showing page 4 and 5. We call this a 'rendition'. We do not navigate
between pages, but we navigate between renditions. Each rendition can contain one or two pages. A rendition is
identified by the page number of the left-most page.

## Fixed layout

This reader supports 'fixed layout' EPUBS only; not 'reflowable' EPUBS. This means that the EPUB file dictates
which content should be shown on what page. A fixed layout EPUB is recognized by its `toc.xthml` file. If this
file has multiple entries in the `<nav epub:type="page-list">` element, then this is a fixed layout.
