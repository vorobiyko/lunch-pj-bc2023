page 60132 LunchMenuCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = LunchMenu;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'MenuCard';
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    Editable = true;
                    NotBlank = true;
                    trigger OnValidate()
                    begin
                        EditableFieldsControl();
                    end;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Line Type';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable= false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    Editable = isActive;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    Editable = true;
                    Enabled = true;
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
                // field("Menu Date"; Rec."Menu Date")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Menu Date';
                // }
            }
        }
    }
    var isActive: Boolean;
     trigger OnOpenPage() 
    begin
        if Rec."Vendor No." = '' then begin
            isActive:= false;  
        end else begin
            isActive:= true;
        end;  
        CurrPage.Update(); 
    end;
    procedure EditableFieldsControl()
    begin
        isActive:= true;
        CurrPage.Update();
    end;

}