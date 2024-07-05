page 60208 "Role Center Admin"
{
    PageType = RoleCenter;
    
    layout
    {
        area(RoleCenter)
        {
                part(Part1; "Vendor View")
                {   Caption = 'Lunch Vendors';
                    ApplicationArea = All;
                }
                part(Part2; "Lunch Order Entry Today View")
                {   Caption = 'Today Order Entry';
                    ApplicationArea = All;
                }
        }  
    }
    actions{
        area(Processing){
            action("Lunch Vendor"){
                RunObject = page "Lunch Vendor View";
                RunPageMode = View;  
            }
            action("Lunch Item"){
                RunObject = page "Lunch Item List View";
                RunPageMode = View;  
            }
            action("Lunch Order Menu"){
                RunObject = page "Lunch Menu View";
                RunPageMode = View; 
            }
            action("Lunch Order Entry"){
                RunObject = page "Lunch Order Entry";
                RunPageMode = View;  
            }
        }
        area(Reporting){
            action("Report Menu Today"){
                RunObject = report "Menu Today";
            }
        }
    }
}