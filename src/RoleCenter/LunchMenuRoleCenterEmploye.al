page 60209 "Role Center Employe"
{
    PageType = RoleCenter;
    ApplicationArea = all;
    Caption = 'Role Center Employe';

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