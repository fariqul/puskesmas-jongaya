# MACCA Hero Carousel + SVG Icons Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a hero background carousel with smooth crossfade and replace all emojis with inline SVG outline icons.

**Architecture:** Keep a single `index.html` with inline CSS and JS. The carousel uses two absolutely positioned slide layers with preloaded background images, toggled in JS. SVG icons are inline markup with a shared CSS class so icons inherit text color and stay consistent.

**Tech Stack:** HTML, CSS, JavaScript (no external libraries)

---

## File Structure

- Modify: `index.html` (HTML, CSS, JS, inline SVG icons)

---

### Task 1: Add shared SVG icon styles

**Files:**
- Modify: `index.html` (CSS)

- [ ] **Step 1: Add base SVG icon CSS classes**

Append these styles after the `.btn` rules so all sections can use them:

```css
.icon-svg {
  width: 18px;
  height: 18px;
  stroke: currentColor;
  fill: none;
  stroke-width: 1.8;
  stroke-linecap: round;
  stroke-linejoin: round;
  flex: 0 0 auto;
}

.icon-svg--sm {
  width: 16px;
  height: 16px;
}

.icon-svg--lg {
  width: 20px;
  height: 20px;
}

.admin-title {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}
```

- [ ] **Step 2: Remove the old emoji helper class**

Delete the `.icon` rule block, since icons are now inline SVG:

```css
.icon {
  width: 22px;
  text-align: center;
}
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "style: add shared svg icon styles"
```

---

### Task 2: Add failing carousel helper tests (TDD)

**Files:**
- Modify: `index.html` (JS)

- [ ] **Step 1: Add a small test harness for carousel helpers**

Insert this before `document.addEventListener("DOMContentLoaded", ...)` so tests can run without DOM setup:

```js
const RUN_TESTS = new URLSearchParams(window.location.search).has("test");

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function runCarouselTests() {
  try {
    assert(getNextIndex(0, 5) === 1, "getNextIndex increments");
    assert(getNextIndex(4, 5) === 0, "getNextIndex wraps to 0");
    assert(shouldReduceMotion({ matches: true }) === true, "shouldReduceMotion true");
    assert(shouldReduceMotion({ matches: false }) === false, "shouldReduceMotion false");

    const el = document.createElement("div");
    setSlideBackground(el, "https://example.com/test.jpg");
    assert(el.style.backgroundImage.includes("test.jpg"), "setSlideBackground sets URL");

    console.log("TEST PASS");
  } catch (err) {
    console.error("TEST FAIL:", err.message);
  }
}

if (RUN_TESTS) {
  runCarouselTests();
}
```

- [ ] **Step 2: Run the tests to confirm failure**

Open `index.html?test=1` in a browser.

Expected: Console shows `TEST FAIL: getNextIndex is not defined` (or another missing helper).

- [ ] **Step 3: Commit failing tests**

```bash
git add index.html
git commit -m "test: add carousel helper test harness"
```

---

### Task 3: Implement carousel helpers and init logic

**Files:**
- Modify: `index.html` (JS)

- [ ] **Step 1: Add carousel helper functions**

Insert these helpers above `document.addEventListener` (near the tests):

```js
function getNextIndex(current, total) {
  if (total <= 0) return 0;
  return (current + 1) % total;
}

function shouldReduceMotion(mql = window.matchMedia("(prefers-reduced-motion: reduce)")) {
  return !!(mql && mql.matches);
}

function setSlideBackground(el, url) {
  el.style.backgroundImage = `url("${url}")`;
}

function preloadImage(url) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(url);
    img.onerror = () => reject(new Error("Image failed to load"));
    img.src = url;
  });
}

function initHeroCarousel() {
  const media = document.querySelector(".hero-media");
  if (!media) return;

  const slideA = media.querySelector(".slide-a");
  const slideB = media.querySelector(".slide-b");
  if (!slideA || !slideB) return;

  const images = [
    "https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=1200&q=75&fit=crop",
    "https://images.unsplash.com/photo-1576765607924-3f7b8410a787?w=1200&q=75&fit=crop",
    "https://images.unsplash.com/photo-1579154203451-0c1f5a8f0e5f?w=1200&q=75&fit=crop",
    "https://images.unsplash.com/photo-1512678080530-7760d81faba6?w=1200&q=75&fit=crop",
    "https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?w=1200&q=75&fit=crop"
  ];

  let activeIndex = 0;
  let isAActive = true;

  setSlideBackground(slideA, images[0]);
  slideA.classList.add("is-active");

  if (shouldReduceMotion()) return;

  setInterval(async () => {
    const nextIndex = getNextIndex(activeIndex, images.length);
    const nextSlide = isAActive ? slideB : slideA;
    const currentSlide = isAActive ? slideA : slideB;

    try {
      await preloadImage(images[nextIndex]);
      setSlideBackground(nextSlide, images[nextIndex]);
      nextSlide.classList.add("is-active");
      currentSlide.classList.remove("is-active");
      isAActive = !isAActive;
      activeIndex = nextIndex;
    } catch (err) {
      // Skip swap on load error; keep current slide visible.
    }
  }, 6000);
}
```

- [ ] **Step 2: Call the carousel init inside DOMContentLoaded**

Add this near the start of the existing `DOMContentLoaded` handler:

```js
initHeroCarousel();
```

- [ ] **Step 3: Re-run tests**

Open `index.html?test=1` in a browser.

Expected: Console shows `TEST PASS`.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: add hero carousel helpers"
```

---

### Task 4: Update navbar + hero markup and hero carousel styles

**Files:**
- Modify: `index.html` (HTML, CSS)

- [ ] **Step 1: Replace navbar brand emoji with SVG logo mark**

Replace this block:

```html
<a class="nav-brand" href="#beranda" aria-label="MACCA">
  <span class="brand-emoji">&#129328;</span>
  <span class="brand-text">MACCA</span>
</a>
```

With:

```html
<a class="nav-brand" href="#beranda" aria-label="MACCA">
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="9"></circle>
    <path d="M12 8v8M8 12h8"></path>
  </svg>
  <span class="brand-text">MACCA</span>
</a>
```

- [ ] **Step 2: Replace hero media markup with two slides + overlay**

Replace:

```html
<div class="hero-media" role="img" aria-label="Ibu hamil di klinik"></div>
```

With:

```html
<div class="hero-media" role="img" aria-label="Ibu hamil di klinik">
  <div class="hero-slide slide-a"></div>
  <div class="hero-slide slide-b"></div>
  <div class="hero-overlay" aria-hidden="true"></div>
</div>
```

- [ ] **Step 3: Replace hero badge + CTA emojis with SVG icons**

Replace the hero badge:

```html
<div class="hero-badge">&#127973; Puskesmas Jongaya &#183; Makassar</div>
```

With:

```html
<div class="hero-badge">
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="9"></circle>
    <path d="M12 8v8M8 12h8"></path>
  </svg>
  <span>Puskesmas Jongaya &#183; Makassar</span>
</div>
```

Replace the two CTA anchors:

```html
<a class="btn btn-primary" href="#daftar">&#128467; Daftar Periksa</a>
<a class="btn btn-outline" href="#edukasi">&#128214; Info ANC</a>
```

With:

```html
<a class="btn btn-primary" href="#daftar">
  <svg class="icon-svg icon-svg--lg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <rect x="3" y="5" width="18" height="16" rx="2"></rect>
    <path d="M8 3v4M16 3v4M3 9h18"></path>
  </svg>
  Daftar Periksa
</a>
<a class="btn btn-outline" href="#edukasi">
  <svg class="icon-svg icon-svg--lg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="9"></circle>
    <circle cx="12" cy="7" r="1"></circle>
    <path d="M12 11v6"></path>
  </svg>
  Info ANC
</a>
```

- [ ] **Step 4: Replace hero-media CSS with slide + overlay rules**

Replace the `.hero-media` block and its `::after` rules with:

```css
.hero-media {
  position: absolute;
  inset: 0;
  overflow: hidden;
}

.hero-slide {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  opacity: 0;
  transition: opacity 1.2s ease;
}

.hero-slide.is-active {
  opacity: 1;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(45, 45, 45, 0.85) 0%, rgba(45, 45, 45, 0) 60%);
}
```

And update the desktop overrides to disable the overlay:

```css
@media (min-width: 768px) {
  .hero-media {
    position: relative;
    min-height: 80vh;
    grid-column: 2;
  }

  .hero-overlay {
    background: none;
  }
}
```

- [ ] **Step 5: Commit**

```bash
git add index.html
git commit -m "feat: update hero markup and navbar icons"
```

---

### Task 5: Replace edukasi list emojis with SVG dot icons

**Files:**
- Modify: `index.html` (HTML)

- [ ] **Step 1: Replace each emoji list icon with a dot SVG**

For every `<li>` in the edukasi cards, replace the emoji span with this inline SVG:

```html
<svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
  <circle cx="12" cy="12" r="3"></circle>
</svg>
```

Example replacement for one list item:

```html
<li>
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="3"></circle>
  </svg>
  <span>1x Trimester 1 - USG skrining awal</span>
</li>
```

Apply the same SVG for all list bullets in the four edukasi cards.

- [ ] **Step 2: Commit**

```bash
git add index.html
git commit -m "feat: replace edukasi emojis with svg dots"
```

---

### Task 6: Replace remaining emojis with SVG icons

**Files:**
- Modify: `index.html` (HTML, CSS)

- [ ] **Step 1: Update the form success card**

Replace:

```html
<div id="formSuccess" class="success-card hidden">
  <span class="success-icon">&#9989;</span>
  <div>
    <strong>Pendaftaran Berhasil!</strong>
    <p>Tim kami akan menghubungi Ibu via WhatsApp segera.</p>
  </div>
</div>
```

With:

```html
<div id="formSuccess" class="success-card hidden">
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="9"></circle>
    <path d="M8.5 12.5l2.5 2.5 4.5-5"></path>
  </svg>
  <div>
    <strong>Pendaftaran Berhasil!</strong>
    <p>Tim kami akan menghubungi Ibu via WhatsApp segera.</p>
  </div>
</div>
```

- [ ] **Step 2: Update location info icons and maps button**

Replace the three info lines and the button with SVG icons:

```html
<div class="info-card">
  <div>
    <strong>
      <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
        <path d="M12 21s6-6.5 6-11a6 6 0 10-12 0c0 4.5 6 11 6 11z"></path>
        <circle cx="12" cy="10" r="2.5"></circle>
      </svg>
      <span>Jl. Andi Tonro No.49, Pa'baeng-Baeng</span>
    </strong>
    <br />Kec. Tamalate, Kota Makassar 90223
  </div>
  <div>
    <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <circle cx="12" cy="12" r="9"></circle>
      <path d="M12 7v5l3 2"></path>
    </svg>
    <span>Senin - Jumat: 08.00 - 14.00 WITA</span>
  </div>
  <div>
    <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <circle cx="12" cy="12" r="9"></circle>
      <path d="M12 8v8M8 12h8"></path>
    </svg>
    <span>Layanan ANC tersedia setiap hari kerja</span>
  </div>
  <a class="btn btn-primary" href="https://maps.google.com/?q=-5.172023,119.42496" target="_blank" rel="noopener">
    <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <path d="M12 21s6-6.5 6-11a6 6 0 10-12 0c0 4.5 6 11 6 11z"></path>
      <circle cx="12" cy="10" r="2.5"></circle>
    </svg>
    Buka di Google Maps
  </a>
</div>
```

- [ ] **Step 3: Update admin header, export button, and delete button**

Replace the admin header title:

```html
<div class="admin-title">&#127973; Admin MACCA - PKM Jongaya</div>
```

With:

```html
<div class="admin-title">
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <circle cx="12" cy="12" r="9"></circle>
    <path d="M12 8v8M8 12h8"></path>
  </svg>
  <span>Admin MACCA - PKM Jongaya</span>
</div>
```

Replace the export button:

```html
<button id="exportBtn" class="btn btn-primary" type="button">&#11015; Export CSV</button>
```

With:

```html
<button id="exportBtn" class="btn btn-primary" type="button">
  <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
    <path d="M12 4v10M8 10l4 4 4-4M5 20h14"></path>
  </svg>
  Export CSV
</button>
```

Replace the delete button inside the table row template in JS:

```js
<td><button class="delete-btn" data-id="${row.id}" title="Hapus">&#128465;</button></td>
```

With:

```js
<td>
  <button class="delete-btn" data-id="${row.id}" title="Hapus" aria-label="Hapus">
    <svg class="icon-svg icon-svg--sm" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
      <path d="M4 7h16M9 7V5h6v2M7 7l1 12h8l1-12M10 11v6M14 11v6"></path>
    </svg>
  </button>
</td>
```

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: replace remaining emojis with svg icons"
```

---

### Task 7: Manual QA for carousel and icon replacements

**Files:**
- Test: `index.html`

- [ ] **Step 1: Carousel behavior**

Open `index.html` in a browser and verify:
- Carousel fades every ~6s with smooth crossfade.
- No flicker when transitioning.
- If `prefers-reduced-motion: reduce` is enabled in OS/browser, only the first image displays.

- [ ] **Step 2: Emoji removal check**

Scan the page to confirm no emojis appear in:
- Navbar, hero badge, CTAs
- Edukasi list bullets
- Success state
- Location info and Maps button
- Admin header, export button, delete button

- [ ] **Step 3: Commit QA note (optional)**

If any fixes were required during QA:

```bash
git add index.html
git commit -m "fix: adjust carousel or svg icon details"
```

---

## Plan Self-Review

- Spec coverage: Carousel + reduced motion + SVG replacements are all covered by Tasks 1-7.
- Placeholder scan: No TODO or undefined steps; all code blocks included.
- Type consistency: Helper names (`getNextIndex`, `shouldReduceMotion`, `setSlideBackground`) are consistent across tests and implementation.
