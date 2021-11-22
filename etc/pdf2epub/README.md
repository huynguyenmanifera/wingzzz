# Wingzzz PDF2EPUB

This tool converts PDFs into EPUBs, by:

1. Converting the PDF into images, one per page.
2. Creating an epub, where every page contains a single image.

This obviously only works well for fixed layout books.

## Usage

1. Via the CLI: `node ./bin.js node /path/to/a/file.pdf /path/to/a/file.epub`
2. Via the web UI at http://localhost:3000 or https://wz-book-converter.herokuapp.com/.

## Tools used

* [ExpressJS](https://expressjs.com/) for the NodeJS server.
* [Poppler - PDF rendering library](https://poppler.freedesktop.org/).
* [Nunjucks - templating library](https://mozilla.github.io/nunjucks/).

## Development

1. `yarn install`
2. `yarn start` (note, server needs to be reloaded manually on code changes).

## Deployment

This application is deployed on Heroku. It uses a Docker deployment, because
it relies on the `pdftoppm` CLI from Poppler.

Deployment is currently manual and can be done as follows:

1. In your terminal navigate to the directory of this tool (`cd etc/pdf2epub`).
2. `heroku container:login` (only need to do this once).
3. `heroku container:push web -a wz-book-converter`.
4. `heroku container:release web -a wz-book-converter`.
