page 60104 LunchVendorList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Vendor List Page';
    SourceTable = LunchVendorTable;

    layout
    {
        area(Content)
        {
            repeater(LunchVendor)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                   
                  
                }
                field("Company"; Rec.Company)
                {
                    ApplicationArea = All;
                   
                }

            }
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