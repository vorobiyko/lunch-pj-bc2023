page 60121 "Lunch Item Creater"
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Lunch Item Creater';
    SourceTable = "Lunch Item";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("Lunch Item")
            {
                field("Vendor No."; Rec."Vendor No.") { }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Description"; Rec.Description) { }
                field("Weight"; Rec.Weight) { }
                field("Price"; Rec.Price) { }
                field("Info Link"; Rec."Info Link") { }
                field("Self-Order"; Rec."Self-Order") { }
                field("Picture"; Rec.Picture)
                {
                    Caption = 'Item Image';
                }
            }
        }
    }
}