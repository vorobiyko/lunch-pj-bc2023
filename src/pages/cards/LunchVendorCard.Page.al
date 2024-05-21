page 60124 LunchVendorCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Lunch Vendor Card';
    
    
    layout
    {
        area(Content)
        {
            // group(GroupName)
            // {
            //     field(Name; NameSource)
            //     {
            //         ApplicationArea = All;
                    
            //     }
            // }
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