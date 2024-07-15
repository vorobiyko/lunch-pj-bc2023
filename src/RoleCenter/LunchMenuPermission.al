permissionset 60213 READ_ONLY_USER
{
    Assignable = true;
    Permissions =
        TableData "Lunch Order Entry" = i,
        TableData "Lunch Item" = r,
        TableData "Lunch Vendor" = r,
        TableData "Lunch Menu" = rm;
}