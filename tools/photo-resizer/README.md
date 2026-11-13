# Photo Resizer

A small Mac app for adding photos to an album on luiz-santos.com. Drag photos or
folders onto it, pick an album, and it saves web-sized copies straight into this
website folder:

- `assets/photos/<album>/name.jpg`: long edge 2048 px, shown in the full-screen viewer
- `assets/photos/<album>/thumbs/name.jpg`: long edge 800 px, shown in the album grid

It turns photos upright, removes camera and location data, and never changes your
originals. For a new album it also creates the album page in `_photograph/`.

## Build the app (once)

Double-click **Build Photo Resizer.command**. It creates **Photo Resizer.app** in
this folder. Move the app wherever you like, for example your Dock.

If macOS says it can't verify the build script, open **System Settings > Privacy &
Security** and click **Open Anyway**, or run this in Terminal from this folder:

    osacompile -o "Photo Resizer.app" "Photo Resizer.applescript"

## Use it

1. Drag photos (or a folder) onto **Photo Resizer.app**.
2. The first time, choose your website folder (the one with `_config.yml`).
3. Pick an existing album or **New album...**. Name new albums starting with the
   year and month, for example `2026-11 Dublin`, so they sort in order.
4. Commit and push the website folder to publish.

Adding photos to one of the old Flickr albums replaces the Flickr embed on that
page with the new gallery.

Photos appear in the album in file-name order, so rename them before dropping
if you want a specific order (for example `01-harbour.jpg`, `02-cliffs.jpg`).

To add captions, list them in the album page's front matter by file name:

    captions:
      01-harbour.jpg: "Howth harbour at sunrise"

To change the sizes or JPEG quality, edit the properties at the top of
`Photo Resizer.applescript` and build again.
