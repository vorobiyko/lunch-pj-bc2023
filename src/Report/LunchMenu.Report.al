report 60200 "Menu Today"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Report List Menu';
    dataset
    {
        dataitem("Lunch Menu"; "Lunch Menu")
        {
            column(Menu_Date; SelectedDate) {}
            column(Item_No; "Item No.") {}
            column(Description; "Item Description") {}
            column(Weight; Weight) {}
            column(Price; Price) {}
            trigger OnPreDataItem()
            begin
                "Lunch Menu".SetCurrentKey("Line No.");
                if "Lunch Menu"."Menu Date" = 0D then begin
                    SelectedDate := System.Today();
                end else begin
                    SelectedDate := "Lunch Menu"."Menu Date";
                end;
                "Lunch Menu".SetRange("Menu Date", SelectedDate);
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
                    field(Date; "Lunch Menu"."Menu Date")
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
    var SelectedDate: Date;
        LunchOrderPage: Page "Lunch Menu View";
}