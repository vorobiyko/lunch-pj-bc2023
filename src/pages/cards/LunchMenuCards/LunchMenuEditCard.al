page 60133 LunchMenuEditCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = LunchMenu;
    AutoSplitKey = true;
    Caption = 'Lunch Menu Edit Card';
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Group Settings';
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Line Type';
                    ValuesAllowed = "Group";
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    ApplicationArea = All;
                    Caption = 'Menu Date';
                    NotBlank=true;
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
                    Caption = 'Description Group';
                    Editable = true;
                    Enabled = true;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Menu Item Entry No.';
                    Editable = false;
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
                    Visible=false;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Order Amount';
                    Visible= false;
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = all;
                    Caption = 'Self-Order';
                    Editable = false;
                    Enabled = false;
                    Visible=false;
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
    var
        ExOrderEntryTable: Record LunchOrderEntry;
        ExMunuTable: Record LunchMenu;
    // Trigger was created for lunch OnModify on LunchMenu.Table. 
   trigger OnOpenPage()
   begin
    CurrPage.Update();
    ConnectorGrouptoItems();
   end;
   
   
    procedure ConnectorGrouptoItems()
    var RecLunchMenuL: Record LunchMenu;
    begin

       

    end;
}