page 60209 "Role Center Employe"
{
    PageType = RoleCenter;
    ApplicationArea = all;

    layout
    {
        area(RoleCenter)
        {
            part("Today Menu"; "Lunch Menu Today View") {}
        }
    }
    actions
    {
        area(processing)
        {
            action("Lunch Order Menu")
            {
                RunObject = page "Lunch Menu View";
                RunPageMode = View;
            }
        }
    }
}