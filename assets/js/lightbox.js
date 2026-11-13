// Full-screen photo viewer for album pages. Each thumbnail links to its
// full-size photo, so without JavaScript a click simply opens the photo.
(function () {
  "use strict";

  var grid = document.querySelector("[data-gallery]");
  if (!grid) return;
  var links = Array.prototype.slice.call(grid.querySelectorAll("a"));
  if (!links.length) return;

  var box = document.createElement("div");
  box.className = "lightbox";
  box.setAttribute("role", "dialog");
  box.setAttribute("aria-modal", "true");
  box.setAttribute("aria-label", "Photo viewer");
  box.hidden = true;
  box.innerHTML =
    '<figure class="lightbox-figure">' +
      '<img class="lightbox-img" alt="">' +
      '<figcaption class="lightbox-caption"></figcaption>' +
    '</figure>' +
    '<p class="lightbox-count" aria-live="polite"></p>' +
    '<button type="button" class="lightbox-btn lightbox-close" aria-label="Close">&times;</button>' +
    '<button type="button" class="lightbox-btn lightbox-prev" aria-label="Previous photo">&#8249;</button>' +
    '<button type="button" class="lightbox-btn lightbox-next" aria-label="Next photo">&#8250;</button>';
  document.body.appendChild(box);

  var img = box.querySelector(".lightbox-img");
  var caption = box.querySelector(".lightbox-caption");
  var count = box.querySelector(".lightbox-count");
  var closeBtn = box.querySelector(".lightbox-close");
  var current = -1, lastFocus = null, touchX = null, touchY = null;

  function preload(i) {
    var link = links[(i + links.length) % links.length];
    var p = new Image();
    p.src = link.href;
  }

  function show(i) {
    current = (i + links.length) % links.length;
    var link = links[current];
    var thumb = link.querySelector("img");
    img.classList.add("is-loading");
    img.onload = function () { img.classList.remove("is-loading"); };
    img.src = link.href;
    img.alt = thumb ? thumb.alt : "";
    var text = link.getAttribute("data-caption") || "";
    caption.textContent = text;
    caption.hidden = !text;
    count.textContent = (current + 1) + " / " + links.length;
    if (links.length > 1) { preload(current + 1); preload(current - 1); }
  }

  function open(i) {
    lastFocus = document.activeElement;
    box.hidden = false;
    document.documentElement.classList.add("lightbox-open");
    show(i);
    closeBtn.focus();
  }

  function close() {
    box.hidden = true;
    document.documentElement.classList.remove("lightbox-open");
    img.removeAttribute("src");
    if (lastFocus && lastFocus.focus) lastFocus.focus();
  }

  links.forEach(function (link, i) {
    link.addEventListener("click", function (e) {
      if (e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
      e.preventDefault();
      open(i);
    });
  });

  closeBtn.addEventListener("click", close);
  box.querySelector(".lightbox-prev").addEventListener("click", function () { show(current - 1); });
  box.querySelector(".lightbox-next").addEventListener("click", function () { show(current + 1); });
  box.addEventListener("click", function (e) {
    if (e.target === box || e.target.classList.contains("lightbox-figure")) close();
  });

  document.addEventListener("keydown", function (e) {
    if (box.hidden) return;
    if (e.key === "Escape") { close(); }
    else if (e.key === "ArrowRight") { show(current + 1); }
    else if (e.key === "ArrowLeft") { show(current - 1); }
    else if (e.key === "Tab") {
      // Keep keyboard focus inside the viewer.
      var buttons = box.querySelectorAll("button");
      var first = buttons[0], last = buttons[buttons.length - 1];
      if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
    }
  });

  box.addEventListener("touchstart", function (e) {
    if (e.touches.length !== 1) return;
    touchX = e.touches[0].clientX; touchY = e.touches[0].clientY;
  }, { passive: true });
  box.addEventListener("touchend", function (e) {
    if (touchX === null) return;
    var dx = e.changedTouches[0].clientX - touchX, dy = e.changedTouches[0].clientY - touchY;
    touchX = touchY = null;
    if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) show(current + (dx < 0 ? 1 : -1));
    else if (dy > 80 && Math.abs(dy) > Math.abs(dx)) close();
  });
})();
