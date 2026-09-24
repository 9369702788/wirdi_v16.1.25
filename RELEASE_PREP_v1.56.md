# Wirdi v1.56.0 (build 22) -- visual identity + Islamic Tools reorganization

Builds on v1.55 (RELEASE_PREP_v1.55.md). As with every previous pass, nothing here
was compiled or run (no Flutter SDK available): run `flutter analyze` and look at
these screens on a device/emulator before shipping.

## Visual identity (design-brief alignment)
- **Colors and fonts already matched the brief exactly** before this pass -- the
  default "Emerald" theme is `#0F766E` / `#D4AF37` / `#F8F9F6` / `#071A17` / `#102925`,
  and the app already uses Tajawal (bundled, no runtime download since v1.54)
  everywhere. No color/font changes were needed or made.
- **New: `WirdiIdentityBackground`** (`lib/shared/widgets/wirdi_identity_background.dart`)
  -- a reusable mosque-skyline-and-crescent illustration (dome, two minarets, stars,
  crescent moon) painted with `CustomPaint` in the app's own brand colors. This is
  the visual-identity asset requested alongside the palette (matching the mood board's
  photographic mosque backgrounds); it's drawn as vector art rather than a photo
  because no image-generation tool was available in this environment -- which also
  means zero licensing/attribution risk, a tiny footprint (no image bytes at all),
  and it renders correctly in both the light and dark theme since it's painted with
  `AppColors`, not baked into a fixed image. Two entry points: default (compact, for
  an AppBar `flexibleSpace`) and `.hero` (taller, for a full-screen banner). The
  proportions were verified by rendering the same geometry at header height, hero
  height, and a very short strip before wiring it into any screen, so it doesn't
  distort at different aspect ratios.
- **Applied to the Home screen's AppBar** (`home_dashboard_screen.dart`): replaced
  the flat 2-color gradient in `flexibleSpace` with `WirdiIdentityBackground`. This
  was an isolated, same-slot swap -- nothing else on the screen (the list below, its
  logic, its data) was touched.
- **Not yet applied to the other ~93 screens.** Rolling this out everywhere in one
  pass was judged too large and too risky to do blind (no compiler available) in a
  single change set. The component is ready to reuse: wrap a screen's `AppBar`
  `flexibleSpace` (compact) or wrap a hero `Stack` at the top of a body (`.hero`) with
  it. Natural next candidates, matching the mood board's own example screens: Qibla,
  Radio "now playing", the Moon-phase screen, and Prayer Times.

## Islamic Tools screen -- reorganized into 8 groups
The 62 tools were one flat scrolling list. They're now grouped by how closely related
they are to a user's daily worship flow, in this display order:

1. القرآن والحفظ / Quran & Memorization (12)
2. الصلاة والقبلة / Prayer & Qibla (11 -- includes Mosque Finder)
3. الصيام ورمضان / Fasting & Ramadan (3)
4. الزكاة والصدقة / Zakat & Charity (6)
5. الأذكار والدعاء / Azkar & Dua (5)
6. المعرفة والحديث / Knowledge & Hadith (10 -- hadith, quizzes, fatwa, articles, etiquette, will)
7. السيرة والتاريخ / Seerah & History (7 -- prophets, history, Hajj/Umrah, Hijri converter, moon phase, Islamic events)
8. التقدم والمزيد / Progress & More (8 -- insights, achievements, bookmarks, My Wirdi, search, radio)

**How it was done safely:** none of the 62 existing `_ToolEntry(...)` blocks (icon,
title, subtitle, and -- critically -- the `builder` that opens the actual screen) were
touched. The category for each tool is a separate, purely-additive list
(`_categoryByIndex`) matched to the existing tools by position, cross-checked
programmatically against an independently-built expected mapping (0 mismatches, 0
missing, all 62 accounted for) before being wired in. A debug-mode assertion in
`_groupedTools()` will fail loudly if a future edit adds or removes a tool without
updating `_categoryByIndex`, instead of silently mis-grouping it. Only the `build()`
method's layout changed, from a flat `ListView.separated` to grouped sections with a
header (icon + bilingual label) per category; the individual tool row's appearance and
`onTap` behavior are byte-for-byte the same widget code as before.

## What was verified vs. not
Verified: every changed and new file parses with zero syntax errors (183 lib files
checked); the 62-tool category mapping was cross-checked against an independent
expected table; the skyline illustration's proportions were checked at three very
different aspect ratios before use. **Not verified:** actual rendering on a device or
in `flutter analyze` -- check that the Home AppBar's title/actions stay legible over
the new background at your test device's text scale, and that the tools screen scrolls
and looks right with real fonts/locale (especially Arabic RTL section headers).

## v1.56.1 (build 23) -- fix for the first real `flutter analyze` run
The first CI run against this code caught a real bug this environment's syntax-only
checks could not: `flutter analyze` failed with `Invalid constant value` at
`islamic_tools_screen.dart:594:86`.

**Cause:** `AppColors.primaryEmerald` and `AppColors.goldAccent` are `static Color get`
getters, not compile-time constants (the app supports switchable color themes) --
documented in this repo's own `MERGE_NOTES.md` from an earlier, identical bug at
v133/v239. The new `_sectionHeader` widget's `Text` style used
`const TextStyle(..., color: AppColors.primaryEmerald)`, which is invalid for the same
reason.

**Fix:** dropped the `const` on that one `TextStyle` (line 594). Re-checked the whole
repo for the same mistake two ways -- a plain substring scan and a balanced-paren scan
that reconstructs each `const` call's full argument list -- and confirmed zero other
occurrences of either getter inside a `const` expression, in this file or anywhere
else in `lib/`.

This is a genuine reminder that everything before this point in the review was
syntax-checked only, never compiled: this class of bug (a non-const value inside a
`const` expression) is invisible to a parser and only shows up under `flutter analyze`
or `dart analyze`, which is exactly what caught it. If another `flutter analyze` run
surfaces something else, paste the log back and it'll get the same targeted fix.

## v1.56.2 (build 24) -- real photos restored and wired in (fixes "الصور مش مضافة")

The previous pass (v1.56.0) only added a hand-drawn vector illustration, and only to
one screen (Home's AppBar). The user pointed out, correctly, that the app's pages
still didn't look like the reference mood board and that no actual images had been
added. Looking into it surfaced a real mistake from an earlier pass:

**The mistake:** during the v1.55 cleanup, `assets/images/ui/` (6 photos --
`home_scenery`, `kaaba_night`, `lantern_sunset`, `moon_night`, `mosque_sunset`,
`quran_mosque`) was deleted as "unused dead weight" because nothing in the code
referenced them. They were real, already-licensed project assets (present in the
originally uploaded project, not fetched from anywhere) that matched the mood
board's own "backgrounds used in the app" section almost exactly -- they just hadn't
been wired into any screen yet. Deleting them instead of asking why they existed was
the actual error, not that they were unreferenced.

**What they actually were:** design-brief mock-up renders, not clean background
photos -- 4 of the 6 had fake UI elements baked directly into the pixels (a back
button and "المدينة" label on `kaaba_night`, three ghost icon circles on
`mosque_sunset`, a hard-coded date stamp on `moon_night`, a full title bar and two
white placeholder cards on `quran_mosque`). That's almost certainly *why* the original
code never used them as real backgrounds -- placing real UI on top would have
duplicated or clashed with the baked-in fake UI. This pass cropped each one down to
the clean photographic part only (verified visually before/after each crop) and
re-encoded all 6 as WebP in `assets/images/identity/` (138 KB total, down from 475 KB
of raw JPEG) -- `assets/images/ui/` was not restored, since these cleaned copies
replace it.

**`WirdiIdentityBackground` now supports real photos**, via a new
`.photo(photo: WirdiIdentityPhoto.xxx)` constructor (photo + dark gradient scrim for
text legibility + optional child) alongside the existing vector variants -- nothing
about the existing vector API changed, so it's purely additive.

**Wired into six screens' AppBars** (found, while doing this, that the app already had
a *different*, pre-existing background mechanism -- a private `_MosaicBg` widget
tiling `wirdi_mosaic.webp` at low opacity, duplicated separately in 10 screen files.
That mechanism already gave the app a consistent decorative AppBar background almost
everywhere; it just wasn't the photographic mood-board look specifically requested):

| Screen | Photo | Was |
|---|---|---|
| Home | `home_scenery` (skyline reflected in water) | vector skyline (v1.56.0) |
| Qibla | `kaaba_night` | `_MosaicBg` tile pattern |
| Quran | `quran_mosque` (Quran cover on green pattern) | `_MosaicBg` tile pattern |
| Moon | `moon_night` | `_MosaicBg` tile pattern |
| Prayer Times | `mosque_sunset` | `_MosaicBg` tile pattern |
| Azkar | `lantern_sunset` | `_MosaicBg` tile pattern (AppBar only -- a second, unrelated low-opacity `_MosaicBg` further down in the screen's body was left untouched) |

Each swap was the same isolated, same-slot change as Home's in v1.56.0 -- only the
`flexibleSpace:` line changed; nothing else on any of these six screens (their actual
functionality, data, lists) was touched. The now-unused private `_MosaicBg` class in
each of these 5 files (it's duplicated per-file, not shared) was deliberately left in
place rather than deleted, since it's a harmless unused-private-class warning at worst
(not an error `flutter analyze` fails on) and removing 5 separate duplicated class
definitions safely was out of scope for this pass.

**Not changed:** Radio, Radio "now playing", Account, and Splash still use
`_MosaicBg`/their own existing background (Splash already had a real photo of its
own from before this work). The other ~87 screens in the app still have no scenic
background at all -- this pass covered the mood board's own example screens (Home,
Quran, Azkar, Qibla, Radio was already photographic, Moon) plus Prayer Times, not
the entire app.

**Verified:** every touched/new file re-parsed with zero syntax errors; the
const/non-const-getter scan (the exact class of bug `flutter analyze` caught in
build 23) was re-run across the whole repo after these changes and found nothing;
every image path the code references was confirmed to exist on disk and be covered by
the `pubspec.yaml` asset declaration. **Not verified:** actual rendering -- check
image contrast/text legibility on Qibla and Moon in particular (their `scrimOpacity`
values were chosen by eye from the cropped preview images, not measured against real
device brightness), and confirm `flutter analyze` is clean (this is the second batch
of Dart code in this project that has never been run through a real compiler).
