# SharePoint Delegation Cheat Sheet

Quick reference I use during reviews. Always confirm against the official Microsoft docs, since delegation support changes over time.

| Function / operator | Delegable to SharePoint? | Notes |
|---|---|---|
| `Filter`, `LookUp` | ✅ Yes | When predicates inside are delegable |
| `=`, `<>`, `<`, `>`, `<=`, `>=` | ✅ Mostly | Numbers, text, dates, Choice `.Value` with `=` |
| `StartsWith` | ✅ Yes | Use instead of `Search` for prefix search |
| `And` / `&&`, `Or` / `\|\|`, `Not` | ✅ Yes | Each side must itself be delegable |
| `Sort`, `SortByColumns` | ✅ Yes | Single column sort |
| `Search` | ❌ No | Evaluated locally on first N rows |
| `in` (substring) | ❌ No | |
| `EndsWith` | ❌ No | |
| `CountRows`, `Sum`, `Average` | ❌ No | Use Power Automate or Dataverse |
| `AddColumns`, `DropColumns`, `ShowColumns` | ⚠️ Partial | Fine as a final shaping step |

**Data row limit:** default 500, maximum 2,000 (Settings → General). Raising it is not a fix — it only hides the problem.

**List view threshold:** for lists above 5,000 items, index every column used in `Filter` or `Sort`.
