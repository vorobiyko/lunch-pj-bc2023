page 60103 LunchOrderEntry
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Order Page';
    SourceTable = LunchOrderEntry;
    SourceTableView = sorting("order Date") order(descending);
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
                    StyleExpr = TypeControl;
                }
                field("Order Date"; Rec."Order Date")
                {
                    StyleExpr = TypeControl;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    StyleExpr = TypeControl;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    StyleExpr = TypeControl;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    StyleExpr = TypeControl;
                }
                field("Menu Item No."; Rec."Menu Item No.")
                {
                    StyleExpr = TypeControl;
                }
                field("Item Description"; Rec."Item Description")
                {
                    StyleExpr = TypeControl;
                }
                field("Quantity"; Rec."Quantity")
                {
                    StyleExpr = TypeControl;
                }
                field("Price"; Rec."Price")
                {
                    StyleExpr = TypeControl;
                }
                field("Amount"; Rec."Amount")
                {
                    StyleExpr = TypeControl;
                }
                field("Status"; Rec."Status")
                {
                    Editable = true;
                    StyleExpr = TypeControl;
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
            action("Mark Posted")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = "Invoicing-Send";
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    Rec.Status:= Rec.Status::Posted;
                    CurrPage.Update();
                end;
            }
        }
    }
    var ExRecStatus: Record LunchOrderEntry;
        TypeControl: Text;
    trigger OnAfterGetRecord()
    begin
        Rec.SetCurrentKey("Order Date");
        StatusStyleControl();
    end;
    procedure StatusStyleControl()
    begin
        ExRecStatus:= Rec;
        case ExRecStatus."Status" of
            ExRecStatus."Status"::"Sent to Vendor":
                begin
                    TypeControl := 'StrongAccent';     
                end;
            ExRecStatus.Status::Posted:
                begin
                    TypeControl := 'Favorable'; 
                end;
            ExRecStatus.Status::Created:
                begin
                    TypeControl:= 'Standard';
                end;

        end;
    end;
}