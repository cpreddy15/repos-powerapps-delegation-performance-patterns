# Canvas App Troubleshooting Checklist

## Incomplete or missing data
- [ ] Any yellow delegation warnings in the editor?
- [ ] List larger than the data row limit?
- [ ] Filter/sort columns indexed in SharePoint?
- [ ] Temporarily set data row limit to 1 to expose non-delegable formulas

## Slow app start
- [ ] Run **Monitor** and sort events by duration
- [ ] Sequential `ClearCollect` calls in `OnStart`? → `Concurrent()`
- [ ] `Navigate()` in `OnStart`? → `App.StartScreen`
- [ ] Data loaded that the first screen doesn't need? → defer to `OnVisible`
- [ ] Pulling all columns? → `ShowColumns`
- [ ] Run **App Checker** → Performance and Formulas sections

## Slow galleries
- [ ] `LookUp` to a data source per row? → local collection
- [ ] Nested galleries over large data?
- [ ] Images loading full-size? → thumbnails
