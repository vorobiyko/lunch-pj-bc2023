page 60121 LunchItemCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                field("Picture"; Rec.Picture)
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
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;
}