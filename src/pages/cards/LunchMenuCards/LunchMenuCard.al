page 60133 LunchMenuCard
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
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Line Type';
                    ValuesAllowed = "Group";
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    Editable = true;
                    Enabled = true;
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
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = all;
                    Caption = 'Self-Order';
                    Editable = false;
                    Enabled = false;
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    ApplicationArea = All;
                    Caption = 'Menu Date';
                }
            }
            group("Items List")
            {
                part("ItemsPart"; "ItemsPart")
                {
                    // Filter on the sales orders that relate to the customer in the card page.
                    SubPageLink = "Parent Menu Item Entry No." = field("Menu Item Entry No.");

                }
            }
        }
    }

    // Trigger was created for lunch OnModify on LunchMenu.Table. 
   trigger OnOpenPage()
   begin
    CurrPage.Update();
   end;
   
}