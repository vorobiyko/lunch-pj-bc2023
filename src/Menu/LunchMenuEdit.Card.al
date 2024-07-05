page 60133 "Lunch Menu Creater"
{
    PageType = Card;

    UsageCategory = Administration;
    SourceTable = "Lunch Menu";
    AutoSplitKey = true;
    Caption = 'Lunch Menu Edit';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Group Settings';
                field("Menu Date"; Rec."Menu Date")
                {
                    Caption = 'Menu Date';
                    NotBlank = true;
                }
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Description Group';
                    Editable = true;
                    Enabled = true;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    Caption = 'Menu Item Entry No.';
                    Editable = false;
                }
                field("Active"; Rec.Active)
                {
                    Caption = 'Active';
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    Caption = 'Order Quantity';
                    Visible = false;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    Caption = 'Order Amount';
                    Visible = false;
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    Caption = 'Self-Order';
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }

            }
            group("Items List")
            {
                part("Group Element Creater"; "Group Element Creater")
                {
                    // Filter on the sales orders that relate to the customer in the card page.
                    SubPageLink = "Parent Menu Item Entry No." = field("Menu Item Entry No.");
                }
            }
        }
    }
    var
        ExOrderEntryTable: Record "Lunch Order Entry";
        ExMunuTable: Record "Lunch Menu";
    // Trigger was created for lunch OnModify on "Lunch Menu".Table. 
    trigger OnOpenPage()
    begin
        CurrPage.Update();
        ConnectorGrouptoItems();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Line Type" := Rec."Line Type"::Group;
    end;


    procedure ConnectorGrouptoItems()
    var
        RecLunchMenuL: Record "Lunch Menu";
    begin



    end;
}