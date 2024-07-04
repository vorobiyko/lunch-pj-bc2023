page 60213 LunchMenuPart
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LunchMenu;
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
                field(Price;Rec.Price){   
                }
                field(Weight;Rec.Weight){
                }
                field("Data"; Rec."Menu Date"){
                    StyleExpr = TypeControl;
                }           
            }
        }
    }

    var TypeControl: Text;
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Line No.");
        Rec.SetFilter("Menu Date", '=%1', System.Today());    
    end;
    trigger OnAfterGetRecord()
    var ExRecStatus: Record LunchMenu;
    begin
        ExRecStatus:= Rec;
        case ExRecStatus."Line Type" of
            ExRecStatus."Line Type"::"Group":
                begin
                    TypeControl := 'Strong';     
                end else begin
                    TypeControl := 'Standart';
                end;
        end;
    end;
}