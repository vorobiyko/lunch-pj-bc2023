page 60103 LunchOrder
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Order Page';
    // SourceTable = TableName;
    
    layout
    {
        area(Content)
        {
            // repeater(GroupName)
            // {
            //     field(Name; NameSource)
            //     {
            //         ApplicationArea = All;
                    
            //     }
            // }
        }
        area(Factboxes)
        {
            
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
}