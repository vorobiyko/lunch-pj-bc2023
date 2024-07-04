page 60210 LunchVendorTablePart
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LunchVendorTable;
    Editable= false;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Company; Rec.Company){}
                field("Vendor No.";Rec."Vendor No."){}
            }
        }
    }
}