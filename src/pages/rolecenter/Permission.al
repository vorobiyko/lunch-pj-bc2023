permissionset 60213 READ_ONLY_USER
{
    Assignable = true;
    // IncludedPermissionSets = SomePermissionSet;
    Permissions = 
        TableData "LunchOrderEntry" = i,
        TableData "LunchItem" = r,
        TableData "LunchVendorTable" = r,
        TableData "LunchMenu" = rm;
}