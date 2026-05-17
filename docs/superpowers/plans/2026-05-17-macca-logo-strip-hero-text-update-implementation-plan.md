# MACCA Logo Strip + Hero Text Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the navbar brand with a three-logo strip plus "Puskesmas Jongaya" text, and update the hero heading to highlight "MACCA" with the expanded name as subtext.

**Architecture:** Single-file `index.html` with inline CSS and HTML changes. Logos are local image files, sized via CSS to keep a single-line strip on mobile. Hero text update stays within existing structure with a lightweight highlight style.

**Tech Stack:** HTML, CSS (no new libraries)

---

## File Structure

- Modify: `index.html` (HTML + CSS)

---

### Task 1: Add failing DOM test for logo strip and hero text

**Files:**
- Modify: `index.html` (JS)

- [ ] **Step 1: Add DOM tests before implementation**

Insert this function inside the existing test harness (near `runCarouselTests`), and call it from `runCarouselTests()`:

```js
function assertBrandAndHeroText() {
  const logoStrip = document.querySelector(".brand-logos");
  const brandText = document.querySelector(".brand-title");
  const heroTitle = document.querySelector(".hero-title");
  const heroSub = document.querySelector(".hero-subtitle");

  assert(logoStrip, "logo strip exists");
  assert(brandText && brandText.textContent.includes("Puskesmas Jongaya"), "brand text updated");
  assert(heroTitle && heroTitle.textContent.includes("MACCA"), "hero title is MACCA");
  assert(heroSub && heroSub.textContent.includes("Media ANC Cerdas"), "hero subtext updated");
}
```

Then update `runCarouselTests()` to call it before `TEST PASS` is printed:

```js
assertBrandAndHeroText();
```

- [ ] **Step 2: Run the tests to confirm failure**

Open `index.html?test=1` in a browser.

Expected: Console shows `TEST FAIL: logo strip exists`.

- [ ] **Step 3: Commit failing tests**

```bash
git add index.html
git commit -m "test: add brand and hero text assertions"
```

---

### Task 2: Update navbar markup for logo strip and brand text

**Files:**
- Modify: `index.html` (HTML)

- [ ] **Step 1: Replace brand markup**

Replace the existing navbar brand anchor with:

```html
<a class="nav-brand" href="#beranda" aria-label="Puskesmas Jongaya">
  <span class="brand-logos" aria-hidden="true">
    <img src="UMI_Makassar_png.png" alt="Logo UMI Makassar" />
    <img src="imgbin-puskesmas-logo-silhouette-talent-show-green-cross-logo-riYgEKa5Tk6LSWCxPdVqSzuCn.jpg" alt="Logo Puskesmas" />
    <img src="Coat_of_Arms_of_City_Makassar.png" alt="Logo Kota Makassar" />
  </span>
  <span class="brand-title">Puskesmas Jongaya</span>
</a>
```

- [ ] **Step 2: Commit**

```bash
git add index.html
git commit -m "feat: add logo strip and brand title"
```

---

### Task 3: Style the logo strip for desktop and mobile

**Files:**
- Modify: `index.html` (CSS)

- [ ] **Step 1: Add logo strip styles**

Add these rules near the navbar styles:

```css
.brand-logos {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.brand-logos img {
  height: 30px;
  width: auto;
  display: block;
  object-fit: contain;
}

.brand-title {
  font-weight: 800;
  font-size: 16px;
}

@media (max-width: 480px) {
  .brand-logos {
    gap: 6px;
  }

  .brand-logos img {
    height: 24px;
  }

  .brand-title {
    font-size: 14px;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add index.html
git commit -m "style: add logo strip sizing"
```

---

### Task 4: Update hero heading and subtext with highlight

**Files:**
- Modify: `index.html` (HTML + CSS)

- [ ] **Step 1: Update hero H1 and paragraph**

Replace the hero title and subtext with:

```html
<h1 class="hero-title"><span class="hero-highlight">MACCA</span></h1>
<p class="hero-subtitle">Media ANC Cerdas, Cepat dan Akurat</p>
```

- [ ] **Step 2: Add highlight styling**

Add these styles near the hero rules:

```css
.hero-title {
  font-size: var(--fs-2xl);
  font-weight: 800;
  margin: 12px 0;
  line-height: 1.2;
}

.hero-subtitle {
  margin: 0 0 18px;
}

.hero-highlight {
  position: relative;
  display: inline-block;
  padding: 2px 10px;
  border-radius: 999px;
  background: rgba(125, 168, 123, 0.2);
  color: #fff;
}

@media (min-width: 768px) {
  .hero-highlight {
    color: #fff;
  }
}
```

- [ ] **Step 3: Re-run tests**

Open `index.html?test=1` in a browser.

Expected: Console shows `TEST PASS`.

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: update hero brand text"
```

---

### Task 5: Manual QA

**Files:**
- Test: `index.html`

- [ ] **Step 1: Navbar logo strip**

Verify:
- Logos appear in order (UMI, Puskesmas, Kota Makassar).
- Logos stay on one line on mobile.
- Brand text reads "Puskesmas Jongaya".

- [ ] **Step 2: Hero text**

Verify:
- Hero H1 reads "MACCA" with highlight.
- Subtext reads "Media ANC Cerdas, Cepat dan Akurat".

- [ ] **Step 3: Commit QA fixes (optional)**

If any tweaks were needed:

```bash
git add index.html
git commit -m "fix: adjust logo strip or hero text"
```

---

## Plan Self-Review

- Spec coverage: Logo strip + brand text + hero title/subtext updates all mapped to Tasks 2-4.
- Placeholder scan: No TODO or undefined steps.
- Type consistency: `.brand-logos`, `.brand-title`, `.hero-title`, `.hero-subtitle` are consistent.
