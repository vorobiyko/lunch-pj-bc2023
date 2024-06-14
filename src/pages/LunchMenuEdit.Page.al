page 60102 LunchMenuEdit
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Menu Edit Page';
    SourceTable = LunchMenu;
    CardPageId = LunchMenuCard;
    Editable = true;
    AutoSplitKey = true;
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            repeater("Lunch Menu Edit")
            {
                IndentationColumn = Rec."Indentation";
                IndentationControls = "Line Type", "Line No.";
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Line Type';
                    StyleExpr = TypeControl;

                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    Editable = false;
                    Enabled = false;
                }
                field("Weight"; Rec."Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Weight';
                    Editable = false;
                    Enabled = false;
                    
                }
                field("Price"; Rec."Price")
                {
                    ApplicationArea = All;
                    Caption = 'Price';
                    Editable = false;
                    Enabled = false;
                }
                field("Indentation"; Rec."Indentation")
                {
                    ApplicationArea = All;
                    Caption = 'Indentation';
                    Visible = false;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Menu Item Entry No.';
                }
                field("Active"; Rec.Active)
                {
                    ApplicationArea = all;
                    Caption = 'Active';
                    Visible =false;
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Order Quantity';
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Order Amount';
                }

                // field("Previous Quantity"; Rec."Previous Quantity")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Previous Quantity';
                // }
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = all;
                    Caption = 'Self-Order';
                    Editable = false;
                    Enabled = false;
                }
                field("Parent Menu Item Entry No."; Rec."Parent Menu Item Entry No.")
                {
                    ApplicationArea = all;
                    Caption = 'Parent Menu Item Entry No.';
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    ApplicationArea = All;
                    Caption = 'Menu Date';
                }
            }
        }
        area(Factboxes)
        {

        }
    }


    actions
    {

        area(Processing)
        {
            action("BtnToSetValue")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }

    }


    var
        TypeControl: Text;
        

    procedure GropeContol()
    var ExRecStatus: Record LunchMenu;
    
    begin
       ExRecStatus:= Rec;
        case ExRecStatus."Line Type" of
            ExRecStatus."Line Type"::"Group":
                begin
                    TypeControl := 'Strong';
                end;
            else begin
                TypeControl := 'Standart';
            end;
        end;
    end;
     procedure SumParams()
    var ExRecSum: Record LunchMenu;
        RecordGroup: Record LunchMenu;
        TotalItemsPrice: Decimal;
        TotalItemsWeight: Decimal;
    begin
        ExRecSum:= Rec;
        ExRecSum.SetCurrentKey("Line No.");
            if ExRecSum."Line Type" = ExRecSum."Line Type"::Group then begin
                RecordGroup:= ExRecSum;
                ExRecSum.SetRange("Parent Menu Item Entry No.", RecordGroup."Menu Item Entry No.");
                repeat
                    TotalItemsPrice := ExRecSum.Price + TotalItemsPrice;
                    TotalItemsWeight := ExRecSum.Weight + TotalItemsWeight;
                until ExRecSum.Next() = 0;
                ExRecSum.Price:= TotalItemsPrice;
                ExRecSum.Weight:= TotalItemsWeight;
                Rec.Price:= ExRecSum.Price;
            end;
    end;
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Line No.");
        Rec.SetAscending("Line No.", false);
    end;
    trigger OnAfterGetRecord()
    begin
        SumParams();
        GropeContol();
    end;



}