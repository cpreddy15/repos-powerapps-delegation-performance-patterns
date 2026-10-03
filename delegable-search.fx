// =====================================================================
// Delegable search over a large SharePoint list ("Requests", 10k+ rows)
// Indexed SharePoint columns: Title, Status, RequesterEmail, Created
// =====================================================================

// ❌ BEFORE — NOT delegable to SharePoint
// Search() and "in" are evaluated locally on the first 500/2000 rows only.
Filter(
    Search(Requests, txtSearch.Text, "Title", "Description"),
    txtSearch.Text in Title || Status.Value = ddStatus.Selected.Value
)

// ✅ AFTER — fully delegable
// galRequests.Items
With(
    { searchText: Trim(txtSearch.Text) },
    SortByColumns(
        If(
            ddStatus.Selected.Value = "All",
            Filter(
                Requests,
                StartsWith(Title, searchText)
            ),
            Filter(
                Requests,
                StartsWith(Title, searchText),
                Status.Value = ddStatus.Selected.Value
            )
        ),
        "Created",
        SortOrder.Descending
    )
)

// ✅ "My requests" — delegable equality on an indexed text column
// (store requester email in a plain text column instead of filtering
//  on Person-column sub-fields for the most reliable delegation)
Filter(
    Requests,
    RequesterEmail = varUserEmail
)

// ✅ Counting rows on large lists
// CountRows() is NOT delegable to SharePoint. Options:
//   1. Show "Showing first N results" instead of an exact count
//   2. Maintain a count in a summary list updated by Power Automate
//   3. Use Dataverse, where CountRows is delegable (with limits)

// ✅ Search-as-you-type without hammering the data source
// txtSearch.DelayOutput = true
