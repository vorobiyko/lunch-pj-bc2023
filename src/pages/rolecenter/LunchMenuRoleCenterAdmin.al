page 60208 RoleCenterAdmin
{
    PageType = RoleCenter;
    
    layout
    {
        area(RoleCenter)
        {
                part(Part1; LunchVendorTablePart)
                {   Caption = 'Lunch Vendors';
                    ApplicationArea = All;
                }
                part(Part2; LunchOrderEntryPart)
                {   Caption = 'Today Order Entry';
                    ApplicationArea = All;
                }
        }  
    }
    actions{
        area(Processing){
            action("Lunch Vendor List Page"){
                RunObject = page LunchVendorList;
                 RunPageMode = View;  
            }
            action("Lunch Item List Page"){
                RunObject = page LunchItemList;
                 RunPageMode = View;  
            }
            action("Lunch Order Menu"){
                RunObject = page LunchOrder;
                RunPageMode = View; 
            }
            action("Lunch Order Page"){
                RunObject = page LunchOrderEntry;
                 RunPageMode = View;  
            }
        }
        area(Reporting){
            action("Report Menu Today"){
                RunObject = report MenuToday;
            }
        }
    }
}