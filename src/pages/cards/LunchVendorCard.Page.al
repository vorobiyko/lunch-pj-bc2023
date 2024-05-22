page 60124 LunchVendorCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Lunch Vendor Card';
    SourceTable = LunchVendorTable;
    
    
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Company; Rec."Company")
                {
                    ApplicationArea = All;
                    Editable = true;
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