page 60126 "Lunch Item Setup No"
{
    ApplicationArea = All;
    Caption = 'Lunch Item Setup';
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
                field("Item Nos."; Rec."Item Nos."){}
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;
}