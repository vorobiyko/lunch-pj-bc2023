page 60202 ItemsPart
{
    PageType = ListPart;
    SourceTable = LunchMenu;
    PopulateAllFields = true;
    Caption = 'Menu Creater';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {   
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    TableRelation = LunchItem."Vendor No."; 
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                    Enabled = true;
                }
                field("Active"; Rec.Active){
                    Editable=false;
                }
                field("Parent Menu Item Entry No."; Rec."Parent Menu Item Entry No.")
                {
                    ApplicationArea = All;
                    Enabled = true;
                }
                field("Weight"; Rec."Weight")
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec.Price)
                {
                    ApplicationArea = All;     
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = All;
                }
                field("Indentation"; Rec.Indentation){
                    ApplicationArea = all;
                    Visible = false;
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
                    Editable = false;
                    Enabled = true;
                }
            }
        }
    }
}