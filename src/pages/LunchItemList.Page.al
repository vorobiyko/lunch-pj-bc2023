page 60101 LunchItemList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Item List Page';
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