# MACCA Logo Strip + Hero Text Update (Design)

Date: 2026-05-17

## Summary
Update the navbar branding to show three official logos in a left-aligned strip and change the hero title to highlight "MACCA" with the expanded name as subtext. Layout remains mobile-first and the rest of the page is unchanged.

## Goals
- Replace the navbar brand with three logos in the top-left (UMI, Puskesmas, Kota Makassar) and brand text "Puskesmas Jongaya".
- Keep the logo strip on a single line on mobile.
- Update hero heading to "MACCA" with a highlight treatment.
- Update hero subtext to "Media ANC Cerdas, Cepat dan Akurat".

## Non-Goals
- No changes to carousel, CTA buttons, or section layout.
- No new fonts or external libraries.
- No changes to admin or form behavior.

## Assets (Local Files)
- UMI logo (left): `UMI_Makassar_png.png`
- Puskesmas logo (center): `imgbin-puskesmas-logo-silhouette-talent-show-green-cross-logo-riYgEKa5Tk6LSWCxPdVqSzuCn.jpg`
- Kota Makassar logo (right): `Coat_of_Arms_of_City_Makassar.png`

## Visual Changes
### Navbar Logo Strip
- Left aligned strip with three logos in this order: UMI, Puskesmas, Kota Makassar.
- Keep logos on a single row in mobile.
- Logo heights:
  - Desktop: ~30px
  - Mobile: ~24-26px
- Gap between logos: ~8px desktop, ~6px mobile.
- Brand text to the right of logos: "Puskesmas Jongaya".

### Hero Text
- H1 becomes: "MACCA".
- Apply a simple highlight style to H1 (underline bar or soft pill). Example: a warm sage underline using `::after` or a background gradient on the text.
- Subtext paragraph becomes: "Media ANC Cerdas, Cepat dan Akurat".

## Implementation Notes
- Replace the existing navbar brand markup with a logo strip container and brand text.
- Use `img` tags for each logo with `alt` text and fixed height via CSS.
- Keep the logo strip inside the existing navbar container to avoid layout shifts.
- H1 highlight should be lightweight: no heavy shadows or oversized backgrounds.

## Accessibility
- Provide `alt` text for each logo.
- Ensure the logo strip remains readable and does not collapse or wrap on mobile.

## Manual QA Checklist
- Logos appear in the correct order (UMI, Puskesmas, Kota Makassar).
- Logos stay on one line in mobile.
- Brand text reads "Puskesmas Jongaya".
- Hero H1 reads "MACCA" with a subtle highlight.
- Subtext reads "Media ANC Cerdas, Cepat dan Akurat".
