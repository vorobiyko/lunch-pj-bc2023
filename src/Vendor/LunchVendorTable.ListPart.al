page 60210 "Vendor View"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Lunch Vendor";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Company; Rec.Company) { }
                field("Vendor No."; Rec."Vendor No.") { }
            }
        }
    }
}