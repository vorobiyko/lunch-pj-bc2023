page 60103 LunchOrderEntry
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Order Page';
    SourceTable = LunchOrderEntry;
    // Editable = false;
    // InsertAllowed = false;
    
    layout
    {
        area(Content)
        {
            repeater(Order)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Item No."; Rec."Menu Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec."Price")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
        }
    } 
    actions
    {
        area(Processing)
        {
            action("Send to Vendor")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = VendorBill;
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    Rec.Status:= Rec.Status::"Sent to Vendor";
                    CurrPage.Update();
                end;
            }
        }
    }
}