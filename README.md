# Obelisk

A high-precision Typst document template engineered for mathematical monographs, course notes, and technical publications. Inspired by the strict geometric discipline of Bauhaus and Russian Constructivism, **Obelisk** treats typography as an architectural problem — locking every element, heading, and block to a cohesive structural canvas.

---

## Key Philosophies

* **Bauhaus-Inspired Aesthetic:** Rejects decorative fluff in favor of heavy typography, active negative space, and dynamic layout vectors.
* **The Absolute Baseline Grid:** Every single line of text, heading, and block element automatically snaps to a rigid vertical rhythm.
* **Print & Publication Ready:** Engineered natively for physical printing. Features asymmetrical, alternating margins with a dedicated ledger column for sidenotes and technical markers.

---

## Core Features & Layout Architecture

1. **Built-in Theorem Environments**: pre-configured environments for mathematical exposition (Theorems, Lemmas, Corollaries, and Proofs).

2. **Grid-Aligned Blocks (`#bblock`)**: Standard block elements can easily throw off a baseline grid due to fractional padding or stroke widths. Obelisk exposes the _baseline block_ `bblock` component, which automatically calculates and pads structural boxes so that the following text snaps perfectly back onto the running baseline. By default, all block equations are wrapped in `#bblock`.

3. **Intentional Page Breaks (`#blank-page`)**: When preparing documents for double-sided publication, forcing a section to start on an odd page can leave an empty facing page. The `blank-page` function inserts a clean break and prints an authoritative, technical layout marker. By default, all top level headings break to an odd page using `#black-page`.

---

## Current Status & Roadmap

**Customization Note:** Layout parameters and fonts are currently hardcoded. Modifying them directly in the code would be straightforward (all constants are at the beginning of `layout.typ`), but I'm planning a more convenient configuration method.
