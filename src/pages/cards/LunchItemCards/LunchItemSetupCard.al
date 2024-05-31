    page 60126 LunchItemSetupCard
{
    ApplicationArea = All;
    Caption = 'Lunch Item Setup Card';
    PageType = Card;
    SourceTable = "Item Setup";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Item Nos."; Rec."Item Nos.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;
}