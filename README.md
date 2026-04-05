# Blog

A minimal Rails blog that reads posts and pages from markdown files and ships as a static site with Parklife on GitHub Pages.

## Stack

- Rails 8 with no database-backed features enabled
- `importmap-rails` and `turbo-rails` for the default Rails JavaScript stack
- [`tailwindcss-rails`](https://github.com/rails/tailwindcss-rails) for styling
- [`kramdown`](https://kramdown.gettalong.org/) for markdown rendering
- [`parklife`](https://github.com/benpickles/parklife) and [`parklife-rails`](https://github.com/benpickles/parklife-rails) for static export

## Content

Posts live in `content/posts` and use this frontmatter:

```yaml
---
title: Starting With Rails and Markdown
slug: starting-with-rails-and-markdown
publish_date: 2026-04-04
tags:
  - rails
  - ai-engineering
---
```

Pages live in `content/pages` and use:

```yaml
---
title: About
slug: about
---
```

Routes:

- `/` lists posts
- `/feed.xml` serves the RSS feed
- `/posts/:slug` shows a post
- `/:slug` shows a page
- `/tags/:slug` shows the tag archive

Page slugs reserve `posts`, `tags`, and `up`, and generated routes are validated for uniqueness.

## Local Development

Install gems:

```sh
bundle install
```

Run Rails:

```sh
bin/rails server
```

Turbo is enabled through importmap in [`app/javascript/application.js`](/Users/joshbebbington/dev/bebbs/blog/app/javascript/application.js), and link prefetching is left at Turbo's default behavior.

Run Tailwind in watch mode in another terminal:

```sh
bin/rails tailwindcss:watch
```

Or run both together with:

```sh
bin/dev
```

Run tests:

```sh
bin/rails test
```

## Static Build

Generate the static site locally:

```sh
bin/static-build
```

The exported site is written to `build/`.

If you want feed links to use a specific absolute URL locally, set `SITE_URL` before building or running the app.

## GitHub Pages

The workflow at `.github/workflows/parklife.yml` builds the app with Parklife and deploys the `build/` output to GitHub Pages when `main` is updated.
