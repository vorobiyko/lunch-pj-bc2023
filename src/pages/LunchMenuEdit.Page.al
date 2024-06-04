page 60102 LunchMenuEdit
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Menu Edit Page';
    SourceTable = LunchMenu;
    CardPageId = LunchMenuCard;
    Editable = false;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater("Lunch Menu Edt")
            {

                IndentationColumn = Rec."Indentation";
                IndentationControls = "Indentation";
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Line Type';
                    StyleExpr = TypeControl;

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
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
    // trigger OnOpenPage()

    // begin
    //     if rec.IsEmpty then begin
    //         Rec."Line Type" := Rec."Line Type"::"Group";
    //         Rec.Insert();
    //     end;


    // end;

    var
        TypeControl: Text;

    procedure GropeContol()

    begin
        // while Rec."Line Type" = Rec."Line Type"::Item do begin

        case Rec."Line Type" of
            Rec."Line Type"::"Group":
                begin
                    TypeControl := 'Strong';


                end;
            Rec."Line Type"::"Item":
                begin
                    TypeControl := 'Standart';

                end;
            else begin
                TypeControl := 'Standart';
            end;
        end;
        // end; 
    end;

    // procedure Group2ItemLinked()
    // var
    //     GroupNumber: Integer;
    // begin
    //    Rec.
    // end;

    trigger OnAfterGetRecord()
     var myList: List of [Integer];
    begin
        GropeContol();
    end;


}