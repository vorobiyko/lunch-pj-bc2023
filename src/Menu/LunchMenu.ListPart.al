page 60213 "Lunch Menu Today View"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Lunch Menu";
    Caption = 'Today Menu';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item Description"; Rec."Item Description")
                {
                    StyleExpr = TypeControl;
                }
                field(Price; Rec.Price) { }
                field(Weight; Rec.Weight) { }
                field("Data"; Rec."Menu Date")
                {
                    StyleExpr = TypeControl;
                }
            }
        }
    }

    var
        TypeControl: Text;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Line No.");
        Rec.SetRange("Menu Date", Today);
    end;

    trigger OnAfterGetRecord()
   
    begin
        case Rec."Line Type" of
            Rec."Line Type"::"Group":
                begin
                    TypeControl := 'Strong';
                end else begin
                TypeControl := 'Standart';
            end;
        end;
    end;
}