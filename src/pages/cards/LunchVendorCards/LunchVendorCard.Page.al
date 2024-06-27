page 60124 LunchVendorCard
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Lunch Vendor Card';
    SourceTable = LunchVendorTable;

    layout
    {
        area(Content)
        {
            group(Genral)
            {
                Caption = 'General';
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                     begin
                         if Rec.AssistEdit(xRec) then
                             CurrPage.Update();
                     end;
                }
                field("Company"; Rec."Company")
                {
                    ApplicationArea = All;
                
                }
            }
        }
    }
}