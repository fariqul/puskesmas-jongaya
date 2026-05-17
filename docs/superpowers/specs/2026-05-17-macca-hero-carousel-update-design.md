# MACCA Hero Carousel + No-Emoji Update (Design)

Date: 2026-05-17

## Summary
Add an auto-rotating hero background carousel (5 images, crossfade, no controls) and replace all emojis across the page with inline SVG outline icons to avoid an AI-slop look. This update keeps the rest of the layout unchanged and lightweight for mobile.

## Goals
- Replace the hero background with a smooth crossfade carousel using 5 fixed Unsplash images.
- Remove every emoji and emoji-like symbol from the entire page.
- Replace emoji with inline SVG outline icons (no external assets).
- Preserve the existing mobile-first layout, color palette, and performance constraints.

## Non-Goals
- No carousel controls (no dots, arrows, swipe, or pause).
- No new external libraries.
- No layout changes outside targeted UI elements.

## Visual Changes
### Hero Carousel
- The hero background becomes a 2-layer crossfade carousel.
- Only one visible image at a time; the next image preloads and fades in.
- Transition: 1.2s opacity crossfade, rotate every 6s.
- If `prefers-reduced-motion` is set, show only the first image and disable rotation.

**Image set (fixed URLs):**
1. https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=1200&q=75&fit=crop
2. https://images.unsplash.com/photo-1576765607924-3f7b8410a787?w=1200&q=75&fit=crop
3. https://images.unsplash.com/photo-1579154203451-0c1f5a8f0e5f?w=1200&q=75&fit=crop
4. https://images.unsplash.com/photo-1512678080530-7760d81faba6?w=1200&q=75&fit=crop
5. https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?w=1200&q=75&fit=crop

### No Emoji Policy (SVG Outline)
Replace all emojis and emoji-like icons with inline SVG outline icons for:
- Navbar brand
- Hero badge and CTA buttons
- Edukasi cards list icons
- Form success state
- Location info and buttons
- Admin header and delete button
- Footer

**Replacement styling:**
- Inline SVG icons only (no external sprite or library).
- Single outline style across the page (1.5-2px stroke, no fills).
- Standard icon size 16-18px; 20px for primary CTAs if needed.
- Decorative icons use `aria-hidden="true"` and `focusable="false"`.
- Where an icon replaces a meaning-bearing emoji, keep the text label next to it.

## Component-Level Changes
### Navbar
- Replace emoji brand with an inline SVG outline logo mark next to "MACCA".
- Remove any emoji from menu/CTA labels; add small SVG icons only if needed for consistency.

### Hero
- Replace static `hero-media` background with two `.hero-slide` layers.
- Keep the same gradient overlay for readability.
- Hero badge uses a small inline SVG outline icon plus text: "Puskesmas Jongaya · Makassar".
- CTA labels include inline SVG outline icons before the text (no emoji).

### Edukasi Cards
- Replace emoji list icons with inline SVG outline icons per bullet.
- Keep list text unchanged; icons are decorative.

### Registration
- Success card uses a check-circle SVG outline icon before the text.

### Location
- Replace emoji prefixes in address/hours/service lines with SVG outline icons.
- Button label uses a small map-pin SVG outline icon + "Buka di Google Maps".

### Admin
- Header uses a small clinic SVG outline icon before the title.
- Delete button uses a trash SVG outline icon; keep accessible label via `aria-label`.

### Footer
- Remove emoji separators; use subtle SVG dot separators or keep `&middot;` where needed.

## Carousel Implementation Details
- HTML:
  - `hero-media` becomes a container with two child divs: `.hero-slide.slide-a` and `.hero-slide.slide-b`.
  - Add a `.hero-overlay` element or a `::after` overlay on the container for gradient.
- CSS:
  - `.hero-slide` is absolute, full cover, opacity transition.
  - `.hero-slide.is-active` uses `opacity: 1`.
- JS:
  - Array of image URLs.
  - Preload each next image before swapping.
  - Interval set to 6000ms, fade duration 1200ms.
  - Skip rotation if `prefers-reduced-motion: reduce`.

## SVG Icon Guidelines
- Use inline SVG markup in HTML (no external files).
- Create a reusable class (e.g., `.icon-svg`) for size, stroke, and alignment.
- Default color inherits from text color; use `stroke="currentColor"`.
- Keep the icon set minimal and consistent to avoid visual noise.

## Performance
- Use fixed-size Unsplash URLs with `w=1200&q=75`.
- Only two layers in DOM at once to minimize memory.

## Manual QA Checklist
- Hero carousel fades smoothly; no flicker on slow network.
- Reduced motion disables rotation.
- No emojis remain anywhere in the UI.
- All text remains readable over hero background.
- Buttons remain >= 48px height.
