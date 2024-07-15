page 60202 "Group Element Creater"
{
    PageType = ListPart;
    SourceTable = "Lunch Menu";
    PopulateAllFields = true;
    Caption = 'Menu Creater';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    TableRelation = "Lunch Item"."Vendor No.";
                }
                field("Item No."; Rec."Item No."){}
                field("Description"; Rec."Item Description"){}
                field("Line No."; Rec."Line No."){}
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    Enabled = true;
                }
                field("Active"; Rec.Active)
                {
                    Editable = false;
                }
                field("Parent Menu Item Entry No."; Rec."Parent Menu Item Entry No.")
                {   
                    Enabled = true;
                }
                field("Weight"; Rec."Weight"){}
                field("Price"; Rec.Price){}
                field("Self-Order"; Rec."Self-Order"){}
                field("Indentation"; Rec.Indentation)
                {
                    Visible = false;
                }
                field("Order Quantity"; Rec."Order Quantity")
                {   
                    Caption = 'Order Quantity';
                }
                field("Order Amount"; Rec."Order Amount")
                {   
                    Caption = 'Order Amount';
                    Editable = false;
                    Enabled = true;
                }
            }
        }
    }
}