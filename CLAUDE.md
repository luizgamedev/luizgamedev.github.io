# luiz-santos.com

Luiz Santos's personal site: a short blog plus a photography portfolio. Jekyll 4.4
with the Moonwalk 0.4.0 theme (gem), always dark, deployed to GitHub Pages by
`.github/workflows/pages.yml` on every push to `master`. Repo:
luizgamedev/luizgamedev.github.io. Domain: luiz-santos.com (was kaze.io; do not
reintroduce kaze.io anywhere).

## Run and check

    bundle install
    bundle exec jekyll serve          # http://localhost:4000
    JEKYLL_ENV=production bundle exec jekyll build   # ads only render in production

There is no Gemfile.lock yet; the first `bundle install` creates it. Commit it.

## How the site is put together

- Theme overrides live in `_layouts/`, `_includes/` and `_sass/site.scss`. The
  theme gem supplies everything else, so check the gem's files before overriding.
- `_data/home.yml`: top nav and footer links. Footer has only email
  (contact@luiz-santos.com), LinkedIn and the feed, on purpose: Luiz removed
  Instagram, Flickr, Twitter and GitHub links.
- Pixel Dublin header (pixel-art Dublin Bay with the Poolbeg chimneys):
  `_includes/pixel_header.html`, drawn by `assets/js/pixel-header.js`, styled in
  `_sass/site.scss`. Full size on the home page, `compact=true` on other pages.
  Posts and albums use a back arrow instead. The script keeps the moon and
  chimneys below the text, pauses when off screen, and stays still for
  reduced-motion users. Fonts: Press Start 2P and Handjet from Google Fonts.
- Permalinks match the old Minimal Mistakes site (`/:categories/:title/`,
  `/photograph/<file name>/`) so old links keep working. Don't change them.
- AdSense client/slot are in `_config.yml` under `adsense`.

## Photo albums

- One Markdown file per album in `_photograph/`. Photos live in
  `assets/photos/<folder>/` (2048 px) with same-named thumbnails (800 px) in
  `assets/photos/<folder>/thumbs/`. Folder = the album's `photo_folder`, or the
  album file name slugified ("2022-05 Barcelona.md" -> `2022-05-barcelona`).
- `_includes/album_photos.html` finds the photos, `photo_gallery.html` renders the
  grid, `assets/js/lightbox.js` is the full-screen viewer (keys, swipe, focus trap).
  Order is file-name order; optional `captions:` map in front matter by file name.
- Albums with local photos show the gallery and hide any old Flickr embed. Albums
  without photos still show their Flickr embed. Luiz no longer uses Flickr.
- `tools/photo-resizer/` is a macOS AppleScript droplet that resizes photos into
  those folders, strips EXIF/GPS, and creates new album pages. Built with
  `osacompile`. It has not been run on a Mac yet; expect to debug it with Luiz.
  Keep its slug rule in step with Jekyll's `slugify`.
- `tools/` and `CLAUDE.md` are excluded from the Jekyll build.

## Open items

- DNS: Pages is set to GitHub Actions with custom domain luiz-santos.com, and
  the first deploy worked. luiz-santos.com DNS is at Fastmail (keep the MX
  records for email) and still points at Fastmail's web hosting: it needs the
  GitHub Pages A records and `www` CNAME luizgamedev.github.io, then "Enforce
  HTTPS". kaze.io (GoDaddy) still points at GitHub; set it to forward to
  https://luiz-santos.com.
- Add luiz-santos.com to AdSense.
- The "2019-08 London" album embeds the Berlin Flickr album by mistake.
- Barcelona header image has "kaze.io" burned into it.
- Posts still link to Luiz's old GitHub projects (github.com/kazenotenshi/...)
  inside the text. Those were left in when the profile links were removed.
