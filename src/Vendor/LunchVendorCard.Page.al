page 60124 "Lunch Vendor Creater"
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Lunch Vendor Creater';
    SourceTable = "Lunch Vendor";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Genral)
            {
                Caption = 'General';
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = false;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Company"; Rec."Company"){}
            }
        }
    }
}