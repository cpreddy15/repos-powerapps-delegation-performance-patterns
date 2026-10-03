# Power Apps Delegation & Performance Patterns

![Power Apps](https://img.shields.io/badge/Power%20Apps-Canvas-742774?style=flat-square)
![Power Fx](https://img.shields.io/badge/Power%20Fx-742774?style=flat-square)
![SharePoint](https://img.shields.io/badge/SharePoint%20Online-10k%2B%20items-038387?style=flat-square)

Practical, copy-ready patterns for two of the most common canvas-app problems I troubleshoot in production:

1. **Delegation** — searches and filters silently returning incomplete results on large SharePoint lists.
2. **Performance** — slow app start caused by heavy `OnStart` logic and repeated lookups.

> Demo patterns with sample data, based on issues I resolved on enterprise apps. No client code is included.

## 🔍 Case 1 — Incomplete search on a 10,000+ item list

**Symptom:** Users reported that search "couldn't find" requests they knew existed.

**Root cause:** The gallery used `Search()` and the `in` operator. Neither is delegable to SharePoint, so Power Apps only evaluated the first 500 rows (the default data row limit) and ignored the rest — with just a yellow warning triangle in the editor.

**Fix:**
- Rewrote filters with delegable functions (`Filter`, `StartsWith`, `=`, `SortByColumns`)
- Added **indexed columns** in SharePoint for every column used in filters (required beyond the 5,000-item list view threshold)
- Split the formula with `If()` so each branch stays fully delegable

**Result:** Complete search results restored for **300 users**.

➡️ [`patterns/delegable-search.fx`](patterns/delegable-search.fx) · [`docs/delegation-cheatsheet.md`](docs/delegation-cheatsheet.md)

## ⚡ Case 2 — 12-second app start

**Symptom:** The app took ~12 seconds before the first screen was usable.

**Root cause:** `OnStart` loaded five lookup lists one after another, called `User()` repeatedly, and used `Navigate()` inside `OnStart`, which blocks rendering.

**Fix:**
- Loaded lookups in parallel with `Concurrent()` and only the columns needed (`ShowColumns`)
- Moved static values to **named formulas** (`App.Formulas`) which evaluate lazily
- Replaced `Navigate()` in `OnStart` with the `App.StartScreen` property
- Deferred non-critical data to the screen that uses it (`OnVisible`)
- Replaced repeated `LookUp()` calls inside galleries with lookups against local collections

**Result:** Load time reduced from **~12s to ~4s** (measured with Power Apps *Monitor*).

➡️ [`patterns/onstart-optimization.fx`](patterns/onstart-optimization.fx)

## 📁 Structure

```
├── patterns/
│   ├── delegable-search.fx
│   └── onstart-optimization.fx
└── docs/
    ├── delegation-cheatsheet.md
    └── troubleshooting-checklist.md
```

## 👤 Author

**Pavan Reddy Cheedeti** — Power Platform Developer · [LinkedIn](https://www.linkedin.com/in/pavan-reddy-ch-a960b7439/)
