page 60209 RoleCenterEmployee
{
    PageType = RoleCenter;
    ApplicationArea = all;
    
    layout
    {
        area(RoleCenter)
        {
                part("Today Menu"; LunchMenuPart){}
        }
    }
    actions{
        area(processing){
            action("Lunch Order Menu"){
                RunObject = page LunchOrder; 
            }
        }
    }
}