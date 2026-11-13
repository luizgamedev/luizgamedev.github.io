-- Photo Resizer
-- Drop photos (or folders of photos) onto this app to add them to an album
-- on luiz-santos.com. Each photo is saved twice inside the website folder:
--   assets/photos/<album>/<name>.jpg          long edge 2048 px, for the viewer
--   assets/photos/<album>/thumbs/<name>.jpg   long edge 800 px, for the grid
-- Location and camera data are removed, and rotation is applied, so the
-- published files are upright and private. Originals are never changed.

use AppleScript version "2.5"
use framework "Foundation"
use framework "AppKit"
use framework "CoreImage"
use scripting additions

property fullSize : 2048
property thumbSize : 800
property jpegQuality : 0.82
property prefsDomain : "com.luiz-santos.photo-resizer"
property appTitle : "Photo Resizer"
property newAlbumLabel : "New album..."

on run
	try
		set choice to button returned of (display dialog "Drop photos or folders onto Photo Resizer to add them to an album on your website." & return & return & "Website folder: " & my siteLabel() buttons {"Cancel", "Change Website Folder...", "Choose Photos..."} default button 3 cancel button 1 with title appTitle)
		if choice is "Change Website Folder..." then
			my chooseSiteFolder()
		else
			set picked to choose file with prompt "Choose the photos to add:" of type {"public.image"} with multiple selections allowed
			my processItems(picked)
		end if
	on error errMsg number errNum
		if errNum is not -128 then my showError(errMsg)
	end try
end run

on open droppedItems
	try
		my processItems(droppedItems)
	on error errMsg number errNum
		if errNum is not -128 then my showError(errMsg)
	end try
end open

-- Main flow ------------------------------------------------------------------

on processItems(theItems)
	set site to my siteFolder()
	set images to my collectImages(theItems)
	set total to count of images
	if total is 0 then
		display dialog "No photos found. Photo Resizer accepts JPEG, PNG, HEIC and TIFF files, or folders that contain them." buttons {"OK"} default button 1 with icon caution with title appTitle
		return
	end if

	set album to my chooseAlbum(site, total)
	set albumSlug to slug of album
	set albumDir to site & "/assets/photos/" & albumSlug
	set thumbDir to albumDir & "/thumbs"
	do shell script "mkdir -p " & quoted form of thumbDir

	set progress total steps to total
	set progress completed steps to 0
	set progress description to "Resizing photos for " & albumName of album
	set firstPhoto to ""
	set problems to {}
	set allPrivate to true

	repeat with i from 1 to total
		set src to item i of images
		set progress additional description to "Photo " & i & " of " & total
		set baseName to my slugify(my fileStem(src))
		if baseName is "" then set baseName to "photo-" & i
		set outName to baseName & ".jpg"
		try
			set cleanFull to my resizePhoto(src, albumDir & "/" & outName, fullSize)
			set cleanThumb to my resizePhoto(src, thumbDir & "/" & outName, thumbSize)
			if not (cleanFull and cleanThumb) then set allPrivate to false
			if firstPhoto is "" then set firstPhoto to outName
		on error errMsg
			set end of problems to (my fileName(src)) & ": " & errMsg
		end try
		set progress completed steps to i
	end repeat

	set added to total - (count of problems)
	set msg to (added as text) & " of " & (total as text) & " photos added to " & quote & albumName of album & quote & "."

	if isNew of album and firstPhoto is not "" then
		my createAlbumPage(site, album, firstPhoto)
		set msg to msg & return & return & "Created the album page _photograph/" & albumSlug & ".md. Open it to add a short description if you like."
	end if

	set msg to msg & return & return & "To publish, commit and push your website folder (for example with GitHub Desktop)."

	if not allPrivate then
		set msg to msg & return & return & "Warning: some photos were resized with a fallback that keeps their camera data, which can include the location where they were taken. Check them before publishing."
	end if

	if problems is not {} then
		set shown to problems
		if (count of shown) > 5 then set shown to (items 1 thru 5 of problems) & {"...and " & ((count of problems) - 5) & " more"}
		set msg to msg & return & return & "Couldn't add:" & return & my joinList(shown, return)
	end if

	set btn to button returned of (display dialog msg buttons {"Show in Finder", "Done"} default button 2 with title appTitle)
	if btn is "Show in Finder" then do shell script "open " & quoted form of albumDir
end processItems

-- Albums ---------------------------------------------------------------------

on chooseAlbum(site, photoCount)
	set listing to do shell script "cd " & quoted form of (site & "/_photograph") & " && ls -1 | grep -i '\\.md$' | sed -E 's/\\.[mM][dD]$//' | sort -r || true"
	set existing to {}
	repeat with aLine in paragraphs of listing
		if (contents of aLine) is not "" then set end of existing to (contents of aLine)
	end repeat

	set options to {newAlbumLabel} & existing
	set picked to choose from list options with title appTitle with prompt "Add " & photoCount & " photos to which album?" default items {newAlbumLabel} OK button name "Continue"
	if picked is false then error number -128
	set picked to item 1 of picked

	if picked is newAlbumLabel then
		set suggestion to (do shell script "date +%Y-%m") & " "
		set albumTitle to text returned of (display dialog "Name the new album. Start with the year and month so albums stay in order, for example: 2026-11 Dublin" default answer suggestion buttons {"Cancel", "Create Album"} default button 2 cancel button 1 with title appTitle)
		set albumTitle to my trimText(albumTitle)
		set albumSlug to my slugify(albumTitle)
		if albumSlug is "" then error "The album name needs at least one letter or number."
		set isNew to not my fileExists(site & "/_photograph/" & albumSlug & ".md")
		return {albumName:albumTitle, slug:albumSlug, isNew:isNew}
	end if

	-- Existing album. Its photo folder is its file name as a slug, which is the
	-- same rule the website uses to find the photos.
	return {albumName:picked, slug:my slugify(picked), isNew:false}
end chooseAlbum

on createAlbumPage(site, album, firstPhoto)
	set albumSlug to slug of album
	set mdPath to site & "/_photograph/" & albumSlug & ".md"
	if my fileExists(mdPath) then return
	set today to do shell script "date +%Y-%m-%d"
	set safeTitle to my replaceText(my replaceText(albumName of album, "\\", "\\\\"), quote, "\\" & quote)
	set lf to linefeed
	set pageText to "---" & lf
	set pageText to pageText & "title: " & quote & safeTitle & quote & lf
	set pageText to pageText & "date: " & today & lf
	set pageText to pageText & "photo_folder: " & albumSlug & lf
	set pageText to pageText & "image: /assets/photos/" & albumSlug & "/" & firstPhoto & lf
	set pageText to pageText & "tags: [Photography]" & lf
	set pageText to pageText & "# excerpt: \"One line shown under the title and in previews\"" & lf
	set pageText to pageText & "# cover: /assets/photos/" & albumSlug & "/thumbs/" & firstPhoto & lf
	set pageText to pageText & "---" & lf & lf
	set pageText to pageText & "<!-- Optional: write a few lines about this album here. -->" & lf
	do shell script "printf '%s' " & quoted form of pageText & " > " & quoted form of mdPath
end createAlbumPage

-- Resizing -------------------------------------------------------------------

-- Returns true when the photo was saved without camera or location data.
on resizePhoto(srcPath, outPath, maxSide)
	try
		my resizeWithCoreImage(srcPath, outPath, maxSide)
		return true
	on error
		my resizeWithSips(srcPath, outPath, maxSide)
		return false
	end try
end resizePhoto

on resizeWithCoreImage(srcPath, outPath, maxSide)
	set ca to current application
	set srcURL to ca's |NSURL|'s fileURLWithPath:srcPath
	set img to ca's CIImage's imageWithContentsOfURL:srcURL
	if img is missing value then error "Couldn't read the photo."

	-- Turn the photo upright using its EXIF orientation (1 means already upright).
	set props to img's |properties|()
	if props is not missing value then
		set exifOrientation to (props's objectForKey:"Orientation")
		if exifOrientation is not missing value then
			set exifOrientation to exifOrientation as integer
			if exifOrientation > 1 and exifOrientation < 9 then set img to (img's imageByApplyingOrientation:exifOrientation)
		end if
	end if

	set {w, h} to my rectSize(img's extent())
	set longSide to w
	if h > longSide then set longSide to h
	set scaleFactor to maxSide / longSide
	if scaleFactor < 1 then
		set scaler to ca's CIFilter's filterWithName:"CILanczosScaleTransform"
		scaler's setValue:img forKey:"inputImage"
		scaler's setValue:scaleFactor forKey:"inputScale"
		scaler's setValue:1.0 forKey:"inputAspectRatio"
		set img to scaler's outputImage()
	end if

	-- A fresh bitmap carries no metadata, so camera and location data are dropped.
	set rep to ca's NSBitmapImageRep's alloc()'s initWithCIImage:img
	if rep is missing value then error "Couldn't resize the photo."
	set saveOptions to ca's NSDictionary's dictionaryWithObject:jpegQuality forKey:(ca's NSImageCompressionFactor)
	set jpegData to rep's representationUsingType:3 |properties|:saveOptions -- 3 = JPEG
	if jpegData is missing value then error "Couldn't save the photo as JPEG."
	set didWrite to jpegData's writeToFile:outPath atomically:true
	if not (didWrite as boolean) then error "Couldn't write " & outPath
end resizeWithCoreImage

-- Fallback using the built-in sips tool. It keeps the camera data.
on resizeWithSips(srcPath, outPath, maxSide)
	set qualityPercent to (round (jpegQuality * 100)) as integer
	do shell script "sips -s format jpeg -s formatOptions " & qualityPercent & " -Z " & maxSide & " " & quoted form of srcPath & " --out " & quoted form of outPath
end resizeWithSips

on rectSize(r)
	try
		return {(item 1 of item 2 of r) as real, (item 2 of item 2 of r) as real}
	on error
		return {(width of |size| of r) as real, (height of |size| of r) as real}
	end try
end rectSize

-- Website folder ---------------------------------------------------------------

on siteFolder()
	set p to my savedSiteFolder()
	if p is "" then set p to my chooseSiteFolder()
	return p
end siteFolder

on siteLabel()
	set p to my savedSiteFolder()
	if p is "" then return "not chosen yet"
	return p
end siteLabel

on savedSiteFolder()
	try
		set p to do shell script "defaults read " & prefsDomain & " siteFolder"
		if p is not "" and my isSiteFolder(p) then return p
	end try
	return ""
end savedSiteFolder

on chooseSiteFolder()
	repeat
		set p to POSIX path of (choose folder with prompt "Select your website folder, the one that contains _config.yml and _photograph:")
		if p ends with "/" and (length of p) > 1 then set p to text 1 thru -2 of p
		if my isSiteFolder(p) then
			do shell script "defaults write " & prefsDomain & " siteFolder " & quoted form of p
			return p
		end if
		display dialog "That folder doesn't look like your website. Choose the folder that contains _config.yml and _photograph." buttons {"Cancel", "Try Again"} default button 2 cancel button 1 with icon caution with title appTitle
	end repeat
end chooseSiteFolder

on isSiteFolder(p)
	try
		do shell script "test -f " & quoted form of (p & "/_config.yml") & " && test -d " & quoted form of (p & "/_photograph")
		return true
	on error
		return false
	end try
end isSiteFolder

-- Files and text ----------------------------------------------------------------

on collectImages(theItems)
	set found to {}
	set nameTests to "-iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' -o -iname '*.heif' -o -iname '*.tif' -o -iname '*.tiff'"
	repeat with anItem in theItems
		set p to POSIX path of (contents of anItem)
		if p ends with "/" and (length of p) > 1 then set p to text 1 thru -2 of p
		set out to do shell script "find " & quoted form of p & " -type f \\( " & nameTests & " \\) ! -name '.*' | sort"
		repeat with aLine in paragraphs of out
			if (contents of aLine) is not "" then set end of found to (contents of aLine)
		end repeat
	end repeat
	return found
end collectImages

on fileName(p)
	return do shell script "basename " & quoted form of p
end fileName

on fileStem(p)
	set n to my fileName(p)
	if n does not contain "." then return n
	set oldDelims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	set parts to text items of n
	set stem to (items 1 thru -2 of parts) as text
	set AppleScript's text item delimiters to oldDelims
	return stem
end fileStem

on fileExists(p)
	try
		do shell script "test -e " & quoted form of p
		return true
	on error
		return false
	end try
end fileExists

-- "2026-11 Cork & Kerry!" -> "2026-11-cork-kerry". Same rule as the website.
on slugify(t)
	return do shell script "printf '%s' " & quoted form of t & " | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null | tr -d '\\047\\140\\136\\042\\176' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'"
end slugify

on trimText(t)
	return do shell script "printf '%s' " & quoted form of t & " | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'"
end trimText

on replaceText(t, findText, replaceWith)
	set oldDelims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to findText
	set parts to text items of t
	set AppleScript's text item delimiters to replaceWith
	set t to parts as text
	set AppleScript's text item delimiters to oldDelims
	return t
end replaceText

on joinList(theList, sep)
	set oldDelims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to sep
	set t to theList as text
	set AppleScript's text item delimiters to oldDelims
	return t
end joinList

on showError(errMsg)
	display dialog "Something went wrong:" & return & return & errMsg buttons {"OK"} default button 1 with icon stop with title appTitle
end showError
