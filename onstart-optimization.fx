// =====================================================================
// App start optimization
// =====================================================================

// ❌ BEFORE — App.OnStart (sequential, blocking, ~12s)
Set(varUser, User());
ClearCollect(colDepartments, Departments);
ClearCollect(colLocations, Locations);
ClearCollect(colCategories, Categories);
ClearCollect(colApprovers, Approvers);
ClearCollect(colMyRequests, Filter(Requests, RequesterEmail = User().Email));
If(
    !IsBlank(LookUp(Approvers, Email = User().Email)),
    Navigate(scrApproverHome),
    Navigate(scrHome)
);

// ✅ AFTER — App.Formulas (named formulas: lazy, always up to date)
varUserEmail = Lower(User().Email);
varIsApprover = !IsBlank(LookUp(colApprovers, Lower(Email) = varUserEmail));
AppThemePrimary = RGBA(116, 39, 116, 1);

// ✅ AFTER — App.OnStart (parallel, only needed columns)
Concurrent(
    ClearCollect(colDepartments, ShowColumns(Departments, ID, Title)),
    ClearCollect(colLocations,   ShowColumns(Locations, ID, Title)),
    ClearCollect(colCategories,  ShowColumns(Categories, ID, Title)),
    ClearCollect(colApprovers,   ShowColumns(Approvers, ID, Title, Email))
);

// ✅ AFTER — App.StartScreen (replaces Navigate in OnStart)
If(varIsApprover, scrApproverHome, scrHome)

// ✅ AFTER — scrMyRequests.OnVisible (deferred: only loads when needed)
ClearCollect(
    colMyRequests,
    Filter(Requests, RequesterEmail = varUserEmail)
);

// ✅ Inside galleries: look up against local collections, not the list
// ❌ LookUp(Departments, ID = ThisItem.DepartmentId).Title   // 1 call per row
// ✅
LookUp(colDepartments, ID = ThisItem.DepartmentId).Title
