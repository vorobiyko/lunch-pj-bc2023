page 60104 LunchVendorList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Vendor List Page';
    SourceTable = LunchVendorTable;
    CardPageId = "LunchVendorCard";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(LunchVendor)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    // ApplicationArea = All;
                    ApplicationArea = All;
                   
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.'; 

                }
                field("Company"; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name Vendor company';

                }
            }
        }
    }
}