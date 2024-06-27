report 60200 MenuToday
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Report List Menu';
    dataset
    {
        dataitem(LunchMenu; LunchMenu)
        {
            column(Menu_Date; SelectedDate){}
            column(Item_No; "Item No."){}
            column(Description; "Item Description"){}
            column(Weight; Weight){}
            column(Price; Price){}
            trigger OnPreDataItem()
            begin
                LunchMenu.SetCurrentKey("Line No.");
                if LunchMenu."Menu Date" = 0D then begin
                    SelectedDate := System.Today();
                end else begin
                    SelectedDate := LunchMenu."Menu Date";
                end;
                LunchMenu.SetRange("Menu Date", SelectedDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Selecting a date for the menu")
                {
                    field(Date; LunchMenu."Menu Date")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = './mySpreadsheet.rdl';
            Caption = 'RDLCLayout';
            Summary = 'RDLC Layout';
        }
    }
    var
        SelectedDate: Date;
        LunchOrderPage: Page LunchOrder;
}