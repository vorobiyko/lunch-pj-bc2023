page 60102 "Lunch Menu View"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Order Menu';
    SourceTable = "Lunch Menu";
    CardPageId = "Lunch Menu Creater";
    Editable = true;
    InsertAllowed = false;
    AutoSplitKey = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater("Lunch Menu Edit")
            {
                IndentationColumn = Rec."Indentation";
                IndentationControls = "Line Type", "Line No.";
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    Editable = false;
                    StyleExpr = TypeControl;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                    StyleExpr = TypeControl;
                    Editable = IsCanModify;
                }
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    StyleExpr = ColorStatus;
                    Editable = IsCanModify;
                }
                field("Line Type"; Rec."Line Type")
                {
                    Caption = 'Line Type';
                    StyleExpr = TypeControl;
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Item Description';
                    StyleExpr = ColorStatus;
                    Editable = IsCanModify;
                }
                field("Weight"; Rec."Weight")
                {
                    Caption = 'Weight';
                    Editable = false;
                    StyleExpr = TypeControl;
                }
                field("Price"; Rec."Price")
                {
                    Caption = 'Price';
                    Editable = false;
                    StyleExpr = TypeControl;
                }
                field("Indentation"; Rec."Indentation")
                {
                    Caption = 'Indentation';
                    Visible = false;
                    Editable = false;
                    StyleExpr = TypeControl;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    Caption = 'Menu Item Entry No.';
                    StyleExpr = TypeControl;
                    Visible = false;
                    Editable = false;
                }
                field("Active"; Rec.Active)
                {
                    Caption = 'Active';
                    StyleExpr = TypeControl;
                    Editable = false;
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    Caption = 'Order Quantity';
                    StyleExpr = TypeControl;
                    Editable = IsCanModifyQuantityGroup;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    Caption = 'Order Amount';
                    StyleExpr = TypeControl;
                    Editable = false;
                }
                field("Previous Quantity"; Rec."Previous Quantity")
                {
                    Caption = 'Previous Quantity';
                    Editable = false;
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    Caption = 'Self-Order';
                    StyleExpr = TypeControl;
                    Editable = IsCanModify;
                }
                field("Parent Menu Item Entry No."; Rec."Parent Menu Item Entry No.")
                {
                    Caption = 'Parent Menu Item Entry No.';
                    StyleExpr = TypeControl;
                    Visible = false;
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    Caption = 'Menu Date';
                    StyleExpr = TypeControl;
                    Editable = IsCanModify;
                }
            }
        }
        area(FactBoxes)
        {
            part("Item Image View"; "Item Image View")
            {
                Caption = 'Items Details';
                SubPageLink = "Item No." = FIELD("Item No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Edit Menu")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Lunch Menu Creater";
            }
            action("Create orders")
            {
                Promoted = true;
                PromotedCategory = Process;
                Image = Add;
                trigger OnAction()
                begin
                    ExLunchMenu.AddRecordToOrder(ExOrderEntry,ExOrderEntryLoop,IsNotEmpty,ExLunchMenu,ItemRec,IsRecExistOrderEntry);
                end;
            }
        }
    }
    var
        TypeControl: Text;
        ColorStatus: Text;
        ExLunchMenu: Record "Lunch Menu";
        ItemRec: Record "Lunch Menu";
        ExOrderEntry: Record "Lunch Order Entry";
        ExOrderEntryLoop: Record "Lunch Order Entry";
        IsRecExistOrderEntry: Boolean;
        IsNotEmpty: Boolean;
        IsCanModify: Boolean;
        IsCanModifyQuantityGroup: Boolean;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Line No.");
        Rec.SetAscending("Line No.", false);
        SetSevenDaysFilter();
    end;

    trigger OnClosePage()
    begin
        ExLunchMenu.AddRecordToOrder(ExOrderEntry,ExOrderEntryLoop,IsNotEmpty,ExLunchMenu,ItemRec,IsRecExistOrderEntry);
        ExLunchMenu.ResetRecordQuantity(ExLunchMenu);
    end;

    trigger OnAfterGetRecord()
    begin
        ExLunchMenu.SumParams();
        GroupContol(Rec);
        CheckActiveRec(Rec);
        SetStyleStatusRec();
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.Update(false);
    end;

    local procedure SetSevenDaysFilter()
    var
        StartDate: Date;
        EndDate: Date;
        LastRecLunch: Record "Lunch Menu";
    begin
        LastRecLunch := Rec;
        if not LastRecLunch.IsEmpty then begin
            LastRecLunch.SetCurrentKey("Menu Date");
            LastRecLunch.FindLast();
            StartDate := LastRecLunch."Menu Date";
            EndDate := StartDate - 7;
            Rec.SetFilter("Menu Date", '%2..%1', StartDate, EndDate);
        end;
    end;
    local procedure GroupContol(var LunchMenuRecord: Record "Lunch Menu"): Text;
    var
        ExRecStatus: Record "Lunch Menu";
    begin
        ExRecStatus := LunchMenuRecord;
        case ExRecStatus."Line Type" of
            ExRecStatus."Line Type"::"Group":
                begin
                    TypeControl := 'Strong';
                    IsCanModifyQuantityGroup := false;
                end else begin
                TypeControl := 'Standart';
                IsCanModifyQuantityGroup := true;
            end;
        end;
        exit(TypeControl);
    end;

    local procedure CheckActiveRec(var LunchMenuRecord: Record "Lunch Menu")
    var
        ExRecStatus: Record "Lunch Menu";
    begin
        ExRecStatus := LunchMenuRecord;
        if ExRecStatus."Line Type" = ExRecStatus."Line Type"::Item then begin
            if ExRecStatus.Active = true then begin
                IsCanModifyQuantityGroup := true;
            end else begin
                IsCanModifyQuantityGroup := false;
            end;
        end;
    end;
    local procedure SetStyleStatusRec()
    begin
        ColorStatus:= 'Standard';
        if not ExOrderEntry.IsEmpty then begin
            ExOrderEntry.FindFirst();
            repeat
                if Rec."Menu Item Entry No." = ExOrderEntry."Menu Item Entry No." then begin
                    case ExOrderEntry."Status" of
                        ExOrderEntry."Status"::"Sent to Vendor":
                            begin
                                ColorStatus := 'StrongAccent';
                            end;
                        ExOrderEntry.Status::Posted:
                            begin
                                ColorStatus := 'Favorable';
                            end;
                        ExOrderEntry.Status::Created:
                            begin
                                ColorStatus := 'Standard';
                            end;
                    end;
                end;
                if Rec."Line Type" = Rec."Line Type"::Group then
                    ColorStatus := 'Strong';
            until ExOrderEntry.Next() = 0;
        end;
    end;
}