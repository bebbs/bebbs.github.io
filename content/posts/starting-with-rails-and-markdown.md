---
title: Starting With Rails and Markdown
slug: starting-with-rails-and-markdown
publish_date: 2026-04-04
tags:
  - rails
  - ai-engineering
---

This site is intentionally simple.

Each post lives in the repository as a markdown file with a little bit of frontmatter for the title, slug, publish date, and tags. That keeps the writing experience lightweight, while still letting Rails do the pleasant work of routing, rendering, and shaping the final HTML.

Because everything is file-backed, the app stays fast to understand. There is no database to set up, no admin interface to maintain, and no hidden content state drifting away from the codebase.

When it's time to deploy, Parklife crawls the app and turns it into a static site that GitHub Pages can host directly.
