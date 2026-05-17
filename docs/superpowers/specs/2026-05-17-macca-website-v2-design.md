# MACCA Website v2 (Mobile-First ANC) Design

Date: 2026-05-17

## Summary
Single-file, mobile-first landing page for MACCA (Media ANC Cerdas, Cepat dan Akurat) at Puskesmas Jongaya, Makassar. The page provides ANC education, online registration, location info, and a lightweight admin dashboard backed by Supabase REST API. All assets are optimized for low bandwidth and Android phones.

## Goals
- Provide a calming, thumb-friendly mobile UX for pregnant mothers in Makassar.
- Deliver clear ANC education in small, scannable cards.
- Enable fast online registration with minimal fields.
- Provide a simple client-side admin dashboard for viewing and managing registrations.
- Keep the page fast: no heavy libraries, minimal animations, optimized images.

## Non-Goals
- Full authentication or role-based access control.
- Server-side rendering or multi-page routing.
- Offline support beyond browser cache.

## Audience and Constraints
- Primary users: pregnant mothers (18-40) in Makassar using Android phones.
- Low to medium digital literacy; big buttons and obvious navigation.
- Occasional slow connectivity; must be lightweight.
- Tone: warm, local, and reassuring with light Makassar phrases.

## Information Architecture (Single Page)
1. Navbar (sticky)
2. Hero CTA
3. ANC Education (4 cards)
4. Online Registration Form
5. Location + Map
6. Footer + Admin Easter Egg
7. Admin Dashboard (view replaces main page after login)

## Visual Style
- Font: Google Fonts Nunito, used for all text.
- Palette:
  - --cream: #FDF6EE
  - --sage: #7DA87B
  - --sage-dark: #4E7A4C
  - --blush: #F2A7A0
  - --warm-white: #FFFFFF
  - --text-dark: #2D2D2D
  - --text-muted: #6B6B6B
  - --border: #E8DDD4
- Typography scale:
  - --fs-xs: 13px
  - --fs-sm: 15px
  - --fs-base: 16px (min body)
  - --fs-md: 18px
  - --fs-lg: 22px
  - --fs-xl: 28px
  - --fs-2xl: 34px
- Buttons: minimum height 48px, rounded pill shape on primary CTAs.

## Layout and Components
### Navbar
- Mobile: logo left ("🤰 MACCA"), hamburger right, sticky 56px height.
- Bottom sheet menu from bottom on click (items: Beranda, Edukasi ANC, Daftar Periksa, Lokasi).
- Desktop (>= 768px): horizontal menu + "Daftar Sekarang" button at right.

### Hero
- Mobile: full 100dvh with background image and bottom gradient overlay.
- Image URL: https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=800&q=75&fit=crop
- Content (white): badge, H1 "Periksa Kehamilan Jadi Lebih Mudah", subtext, two CTA buttons.
- CTA buttons full width on mobile, 12px gap.

### ANC Education Cards
- Section heading centered with pre-label "INFO PENTING".
- Mobile: vertical stacked cards (no grid), full width.
- Desktop: 2-column grid.
- Each card: 16px radius, soft shadow, image 16:9 with rounded top.
- Card data:
  1) Periksa 8 Kali
     - Image: https://images.unsplash.com/photo-1651008376811-b90baee60c1f?w=600&q=75
     - Badge: TRIMESTER 1-2-3 (sage)
     - Points: 1x T1, 2x T2, 5x T3
     - Note: "Tabe' Ibu, ini aturan baru Kemenkes ya!"
  2) Tablet Tambah Darah
     - Image: https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=75
     - Badge: NUTRISI (blush)
     - Points: 90 butir, cegah anemia, lindungi bayi
     - Note: "Minum rutin, jangan bolong-bolong nah!"
  3) Trimester 3 Kritis
     - Image: https://images.unsplash.com/photo-1576671081837-49000212a370?w=600&q=75
     - Badge: TRIMESTER 3 (sage-dark)
     - Points: posisi bayi, air ketuban, tekanan darah
     - Note: "Jangan malas periksa ya, ini masa yang paling penting!"
  4) Peran Suami
     - Image: https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600&q=75
     - Badge: UNTUK SUAMI (accent warm)
     - Points: Antar, Jaga, Siap
     - Note: "Janganki' biarkan istri berjuang sendiri, kodong!"

### Online Registration
- Background: sage full width.
- Card: white, 20px radius, 24px padding, shadow.
- Fields:
  1) Nama lengkap
  2) No WhatsApp (tel)
  3) Usia kehamilan (minggu)
  4) Pilih trimester (select)
  5) Tanggal kunjungan (date)
  6) Keluhan (textarea optional)
- Inputs are 16px+ to avoid iOS zoom.
- Auto-trimester: if usia kehamilan changes, set select to matching trimester and show small badge.

### Location
- Google Maps iframe embed:
  https://maps.google.com/maps?q=-5.172023,119.42496&z=17&output=embed
- Info card below with address, hours, service note.
- CTA button to open Google Maps.

### Footer
- Dark warm background (#2D2D2D), white text.
- Includes project and team details.
- Easter egg: click "MACCA" 5x to open admin login modal.

## Interactions and States
- Smooth scroll for anchor links.
- Fade-up sections with IntersectionObserver.
- Button active scale for tactile feel.
- Registration:
  - Loading: disable button, show spinner and "Mengirim..."
  - Success: hide form, show success card.
  - Error: show inline red message above submit.
- Bottom sheet: open on hamburger, close on overlay tap or close button.

## Data Model (Supabase)
Table: pendaftaran
- id UUID PK
- nama_lengkap TEXT
- no_hp TEXT
- usia_kehamilan INTEGER (1-42)
- trimester TEXT (Trimester 1/2/3)
- keluhan TEXT
- tanggal_kunjungan DATE
- created_at TIMESTAMPTZ

RLS enabled with anon insert/select/delete policies for this demo.

## Supabase Integration
Use REST API with fetch. The JS will store placeholders:
- SUPABASE_URL = "https://YOUR_PROJECT.supabase.co"
- SUPABASE_KEY = "YOUR_ANON_KEY"

Note: Do not store or commit database connection strings in the frontend.

## Client Data Flow
- submitPendaftaran(data): POST to /rest/v1/pendaftaran.
- fetchData(trimesterFilter): GET ordered by created_at desc.
- hapusData(id): DELETE by id.
- exportCSV(data): client-side CSV generation.

## Admin Dashboard
- Login modal with credentials admin / pkmjongaya2025.
- On success, replace main page with admin dashboard view.
- Stats cards: Total, Hari Ini, Trimester 1, Trimester 2, Trimester 3.
- Toolbar: search by name, filter trimester, export CSV.
- Data table:
  - Columns: No, Nama, No WA, Usia, Trimester, Tgl Kunjungan, Keluhan, Waktu Daftar, Hapus
  - Zebra striping, scrollable on mobile.
  - Pagination: 10 rows per page, Prev/Next.
- Empty state: friendly message and simple illustration.

## Error Handling
- Registration errors: show message without losing inputs.
- Fetch errors in admin: show banner and allow retry.
- Delete errors: show small toast message and keep row.

## Performance
- No external JS libraries; only Google Fonts.
- Use lazy loading on images where possible.
- Minimal CSS animations.

## Accessibility
- Minimum 16px body text.
- Buttons min height 48px.
- High contrast for text on sage background.
- Clear focus styles on inputs.

## Testing Plan (Manual)
- Mobile viewport 360-414px:
  - All text readable and buttons thumb-friendly.
  - Navbar bottom sheet opens and closes correctly.
  - Hero CTAs visible with gradient overlay.
- Form:
  - Validation for required fields and date range.
  - Auto-trimester logic works for 1-13, 14-27, 28-42.
  - Loading, success, and error states display correctly.
- Admin:
  - Footer click 5x opens modal.
  - Login success shows dashboard; logout returns to main page.
  - Search, filter, pagination, delete, and export CSV all work.

## Deployment Notes
- Deploy as static site to Vercel.
- Ensure SUPABASE_URL and SUPABASE_KEY are set in the HTML before deploy.
