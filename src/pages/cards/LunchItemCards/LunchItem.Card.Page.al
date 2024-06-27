page 60121 LunchItemCard
{
    PageType = Card;
    UsageCategory = None;
    Caption = 'Lunch Item Card';
    SourceTable = LunchItem; 
    layout
    {
        area(Content)
        {
            group("Lunch Item")
            {
                 field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    Editable = false;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Weight"; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field("Info Link"; Rec."Info Link")
                {
                    ApplicationArea = All;
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = All;
                }
                field("Picture"; Rec.Picture){
                    ApplicationArea= all;
                    Caption = 'Item Image';
                    
                }
            }
        }  
    }
}