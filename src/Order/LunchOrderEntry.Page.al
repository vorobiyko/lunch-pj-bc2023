page 60103 "Lunch Order Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Order';
    SourceTable = "Lunch Order Entry";
    SourceTableView = sorting("Order Date") order(descending);
    Editable = false;
    InsertAllowed = false;
    RefreshOnActivate = true;

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
                    PostSelectedOrder();
                end;
            }
            action("Check Posted")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = Refresh;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PrevRec: Record "Lunch Order Entry";
                begin
                    if not Rec.IsEmpty then begin
                        Rec.SetCurrentKey("Vendor No.");
                        Rec.SetRange(Status, Rec.Status::"Sent to Vendor");
                        if Rec.FindFirst() then begin
                            repeat
                                if Rec.Status = Rec.Status::"Sent to Vendor" then begin
                                    if ApiPage.GetVendorInfo(Rec."Vendor No.",PrevRec."Vendor No.",Rec."Menu Item Entry No.") then
                                        Rec.Status := Rec.Status::Posted;
                                    Rec.Modify();
                                end;
                                PrevRec := Rec;
                            until Rec.Next() = 0;
                        end;
                    end;
                    Rec.Reset();
                    Rec.SetCurrentKey("Order Date", "Vendor No.");
                end;
            }
            action("Show History")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = History;
                trigger OnAction()
                begin
                    Rec.SetFilter("Order Date", '');
                end;
            }
            action("Remove All Orders")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = "Invoicing-MDL-Delete";
                trigger OnAction()
                begin
                    Rec.DeleteAll();
                end;
            }
        }
    }
    var
        ExRecStatus: Record "Lunch Order Entry";
        TypeControl: Text;
        ApiPage: Page "Vendor API";

    trigger OnAfterGetRecord()
    begin 
        StatusStyleControl();
    end;
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Order Date");
        SetDateFilter();
    end;
    
    local procedure StatusStyleControl()
    begin
        ExRecStatus := Rec;
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
                    TypeControl := 'Standard';
                end;

        end;
    end;
    local procedure PostSelectedOrder()
    var SelectedRec: Record "Lunch Order Entry";
    begin
        SelectedRec:= Rec;
        CurrPage.SetSelectionFilter(SelectedRec);
        SelectedRec.PostSelectedHandler(SelectedRec, ApiPage);
        CurrPage.Update();
             
    end;
    local procedure SetDateFilter()
    var
        StartDate: Date;
        EndDate: Date;
    begin
        ExRecStatus := Rec;
        if not ExRecStatus.IsEmpty then begin
            ExRecStatus.SetCurrentKey("Order Date");
            ExRecStatus.FindLast();
            StartDate := System.Today;
            EndDate := StartDate + 1;
            Rec.SetFilter("Order Date", '%1..%2', StartDate, EndDate);
        end;
    end;
}