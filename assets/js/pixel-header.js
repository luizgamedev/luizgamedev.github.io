// Pixel-art Dublin Bay at dusk: sky, stars, moon, hills, the Poolbeg chimneys
// and the sea. Drawn at low resolution and scaled up by CSS so pixels stay crisp.
(function () {
  "use strict";

  var canvas = document.querySelector(".pixel-scene");
  if (!canvas || !canvas.getContext) return;
  var ctx = canvas.getContext("2d");

  var reduceQuery = window.matchMedia ? window.matchMedia("(prefers-reduced-motion: reduce)") : null;
  function motionAllowed() { return !(reduceQuery && reduceQuery.matches); }

  var SKY = ["#0b0d1c", "#161a33", "#3b2a5c", "#7a3a6a", "#c2457a", "#ef8a4c"];
  var BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]];
  function dither(x, y) { return (BAYER[y & 3][x & 3] + 0.5) / 16; }

  function rng(seed) {
    return function () {
      seed |= 0; seed = seed + 0x6D2B79F5 | 0;
      var t = Math.imul(seed ^ seed >>> 15, 1 | seed);
      t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
      return ((t ^ t >>> 14) >>> 0) / 4294967296;
    };
  }

  var W = 0, H = 0, scene = null, sky = null;

  function build() {
    var cssW = canvas.parentElement.clientWidth || 780;
    var scale = cssW < 520 ? 3 : 4;
    var rows = parseInt(canvas.getAttribute("data-rows"), 10) || 110;
    W = Math.ceil(cssW / scale);
    H = rows + (cssW < 520 ? Math.round(rows * 0.35) : 0);
    canvas.width = W;
    canvas.height = H;

    var r = rng(42), stars = [], far = [], near = [];
    for (var i = 0; i < W * H / 90; i++) stars.push([r() * W | 0, r() * H * 0.45 | 0, r()]);
    var a = H * 0.62, b = H * 0.7;
    for (var x = 0; x < W; x++) {
      a += (r() - 0.5) * 1.2 + (H * 0.6 - a) * 0.02; far.push(a | 0);
      b += (r() - 0.5) * 0.8 + (H * 0.71 - b) * 0.03; near.push(b | 0);
    }
    // Keep the moon clear of the title and nav: put it just below the last line
    // of text. On short headers that means it rises from behind the hills.
    var pxPerRow = canvas.getBoundingClientRect().height / H || scale;
    var textBottom = 0, header = canvas.parentElement, items = header.querySelectorAll(".pixel-copy > *");
    var top = header.getBoundingClientRect().top;
    for (var j = 0; j < items.length; j++) textBottom = Math.max(textBottom, items[j].getBoundingClientRect().bottom - top);
    var sea = Math.round(H * 0.74);
    scene = {
      stars: stars, far: far, near: near,
      sea: sea,
      cx: Math.round(W * 0.8),
      textRow: Math.ceil(textBottom / pxPerRow),
      mx: Math.round(W * 0.62),
      my: Math.min(Math.max(Math.round(H * 0.2), Math.ceil(textBottom / pxPerRow) + 9), sea - 4)
    };

    // The sky never changes, so render it once and reuse it every frame.
    sky = document.createElement("canvas");
    sky.width = W; sky.height = scene.sea;
    var s = sky.getContext("2d");
    for (var y = 0; y < scene.sea; y++) {
      var f = y / scene.sea * (SKY.length - 1), k = Math.floor(f), frac = f - k;
      for (var xx = 0; xx < W; xx++) {
        s.fillStyle = SKY[frac > dither(xx, y) ? Math.min(k + 1, SKY.length - 1) : k];
        s.fillRect(xx, y, 1, 1);
      }
    }
  }

  function draw(t, animate) {
    var d = scene, x, y;
    ctx.drawImage(sky, 0, 0);

    for (var i = 0; i < d.stars.length; i++) {
      var st = d.stars[i], alpha = 0.3 + st[2] * 0.6;
      if (animate && st[2] > 0.7) alpha *= 0.5 + 0.5 * Math.sin(t / 380 + st[0]);
      ctx.fillStyle = "rgba(242,230,201," + alpha.toFixed(2) + ")";
      ctx.fillRect(st[0], st[1], 1, 1);
    }

    var mr = 6;
    for (y = -mr; y <= mr; y++) for (x = -mr; x <= mr; x++) {
      if (x * x + y * y > mr * mr) continue;
      ctx.fillStyle = (x + 2) * (x + 2) + (y - 1) * (y - 1) < 6 ? "#fff4d6" : "#f2e6c9";
      ctx.fillRect(d.mx + x, d.my + y, 1, 1);
    }

    ctx.fillStyle = "#2a2147";
    for (x = 0; x < W; x++) ctx.fillRect(x, d.far[x], 1, d.sea - d.far[x]);
    ctx.fillStyle = "#171330";
    for (x = 0; x < W; x++) ctx.fillRect(x, d.near[x], 1, d.sea - d.near[x]);

    // Poolbeg chimneys: red and white bands, with a blinking aircraft light on top.
    // Full height is about half the scene, but never tall enough to reach the text.
    var ch = Math.max(8, Math.min(Math.round(H * 0.5), d.sea - d.textRow - 3)), chimneys = [0, 9];
    for (i = 0; i < chimneys.length; i++) {
      var x0 = d.cx + chimneys[i];
      for (y = d.sea - ch; y < d.sea; y++) {
        ctx.fillStyle = Math.floor((y - (d.sea - ch)) / 5) % 2 ? "#e9e1d3" : "#b8383b";
        ctx.fillRect(x0, y, 4, 1);
        ctx.fillStyle = "rgba(0,0,0,.35)";
        ctx.fillRect(x0 + 3, y, 1, 1);
      }
      var lit = !animate || Math.floor(t / 700 + chimneys[i]) % 2 === 0;
      ctx.fillStyle = lit ? "#ff4b4b" : "#5a1f24";
      ctx.fillRect(x0 + 1, d.sea - ch - 1, 2, 1);
    }
    ctx.fillStyle = "#1a1530";
    ctx.fillRect(d.cx - 6, d.sea - 6, 26, 6);

    for (y = d.sea; y < H; y++) {
      ctx.fillStyle = y % 2 ? "#0d1024" : "#10142c";
      ctx.fillRect(0, y, W, 1);
    }
    var shift = animate ? Math.floor(t / 260) : 0;
    for (y = d.sea + 1; y < H; y += 2) {
      for (x = 0; x < W; x++) {
        var k = (x * 7 + y * 13 + shift * (y % 3 + 1)) % 23;
        if (Math.abs(x - d.mx) < 5 + (y - d.sea) * 0.4 && k < 9) { ctx.fillStyle = "#cbbf9f"; ctx.fillRect(x, y, 1, 1); }
        else if (k === 0) { ctx.fillStyle = "#3b2a5c"; ctx.fillRect(x, y, 2, 1); }
        else if (Math.abs(x - d.cx - 6) < 6 && k < 3) { ctx.fillStyle = "#b8383b"; ctx.fillRect(x, y, 1, 1); }
      }
    }
  }

  // Ticks a few times a second, and only while the header is on screen.
  var visible = true, last = 0, frame = 0;
  function loop(t) {
    frame = 0;
    if (!visible || document.hidden || !motionAllowed()) return;
    if (t - last > 120) { last = t; draw(t, true); }
    frame = requestAnimationFrame(loop);
  }
  function start() {
    if (!frame && visible && !document.hidden && motionAllowed()) frame = requestAnimationFrame(loop);
  }
  function redraw() {
    build();
    draw(performance.now(), false);
    canvas.classList.add("is-ready");
    start();
  }

  redraw();
  // Web fonts change the height of the text, so place the moon again once they load.
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(redraw);

  var resizeTimer;
  window.addEventListener("resize", function () {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(function () {
      var cssW = canvas.parentElement.clientWidth;
      if (Math.ceil(cssW / (cssW < 520 ? 3 : 4)) !== W) redraw();
    }, 150);
  });
  document.addEventListener("visibilitychange", start);
  if (reduceQuery && reduceQuery.addEventListener) {
    reduceQuery.addEventListener("change", function () { draw(performance.now(), false); start(); });
  }
  if ("IntersectionObserver" in window) {
    new IntersectionObserver(function (entries) {
      visible = entries[0].isIntersecting;
      start();
    }).observe(canvas);
  }
})();
