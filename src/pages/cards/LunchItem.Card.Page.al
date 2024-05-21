page 60121 LunchItemCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Lunch Item Card';
    // SourceTable = TableName;
    
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