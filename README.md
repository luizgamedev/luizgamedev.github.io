# luiz-santos.com

Personal site built with [Jekyll](https://jekyllrb.com) and the [Moonwalk](https://github.com/abhinavs/moonwalk) theme, deployed by GitHub Actions.

## Run locally

    bundle install
    bundle exec jekyll serve

## Deploy

Every push to `master` runs `.github/workflows/pages.yml`, which builds the site and publishes it to GitHub Pages.

Repository settings needed once, under **Settings > Pages**:

- **Source:** GitHub Actions
- **Custom domain:** `luiz-santos.com`

## Add content

- Blog post: add a Markdown file to `_posts/`.
- Photo album: drag photos onto **Photo Resizer** (in `tools/photo-resizer/`, see its README). It saves web-sized copies to `assets/photos/<album>/` and creates the album page in `_photograph/`. An album shows every photo in its folder, in file-name order.
- Navigation and footer links: edit `_data/home.yml`.
- Colors and layout tweaks: edit `_sass/site.scss`.
- Pixel header: the tagline is `pixel_header.tagline` in `_config.yml`; the scene is drawn by `assets/js/pixel-header.js` and styled in `_sass/site.scss`.
