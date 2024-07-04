page 60211 LunchOrderEntryPart
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LunchOrderEntry;
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
                cuegroup(TodayMenuPrice)
                {
                    field(Price; SumPrice)
                    {
                        Style = Favorable;
                        trigger OnDrillDown()
                        begin
                            // Message('h');
                        end;
                    }
                }
            }
        }

    }

    var
        SumPrice: Decimal;
        CurrRec: Record LunchOrderEntry;

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