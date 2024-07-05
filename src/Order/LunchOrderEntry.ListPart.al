page 60211 "Lunch Order Entry Today View"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Lunch Order Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item Description"; Rec."Item Description"){}
                field("Order Date"; Rec."Order Date"){}
                field(Status; Rec.Status){}
                field(Quantity; Rec.Quantity){}
            }
            group(Total)
            {
                cuegroup("Today Menu Price")
                {
                    field(Price; SumPrice)
                    {
                        Style = Favorable;
                        trigger OnDrillDown()
                        begin
                        end;
                    }
                }
            }
        }

    }

    var SumPrice: Decimal;
        CurrRec: Record "Lunch Order Entry";

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Order Date");
        Rec.SetFilter("Order Date", '=%1', System.Today());
        CurrRec.FindFirst();
        repeat
            SumPrice := CurrRec.Price + SumPrice;
        until CurrRec.Next() = 0;
    end;
}