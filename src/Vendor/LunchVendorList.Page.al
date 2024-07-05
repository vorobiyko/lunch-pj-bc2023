page 60104 "Lunch Vendor View"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Vendor List';
    SourceTable = "Lunch Vendor";
    CardPageId = "Lunch Vendor Creater";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LunchVendor)
            {
                field("Vendor No."; Rec."Vendor No.") { }
                field("Company"; Rec.Company)
                {
                    ToolTip = 'Name Vendor company';
                }
            }
        }
    }
}