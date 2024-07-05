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
                    AddRecordToOrder();
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
        AddRecordToOrder();
        ResetRecordQuantity();
    end;

    trigger OnAfterGetRecord()
    begin
        SumParams();
        GroupContol(Rec);
        CheckActiveRec(Rec);
        SetStyleStatusRec();
    end;

    procedure SetSevenDaysFilter()
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

    procedure AddRecordToOrder()
    begin
        if ExOrderEntry.IsEmpty then begin
            IsNotEmpty := false;
        end else begin
            IsNotEmpty := true;
        end;
        if Dialog.Confirm('Send Menu Items to Create Order?') then begin
            ExLunchMenu.SetCurrentKey("Line No.");
            ExOrderEntryLoop.SetCurrentKey("Entry No.");
            repeat
                if ExLunchMenu.CheckGroupHandler() then begin
                    ItemRec.SetCurrentKey("Line No.");
                    ItemRec.SetRange("Line No.", ExLunchMenu."Line No." + 1, ExLunchMenu."Line No." + 9999);
                    if ItemRec.Count() > 0 then begin
                        ItemRec.Next();
                        repeat
                            if IsNotEmpty then begin
                                if IsRecExistOrderEntry then begin
                                    IsRecExistOrderEntry := false;
                                end;
                                if ItemRec.Active = false then begin
                                    IsRecExistOrderEntry := true;
                                end;
                                if (ExOrderEntryLoop.FindSet()) then begin
                                    repeat
                                        if ((ItemRec."Menu Item Entry No." = ExOrderEntryLoop."Menu Item Entry No.")) then begin
                                            IsRecExistOrderEntry := true;
                                            break;
                                        end;
                                    until ExOrderEntryLoop.Next() = 0;
                                end;
                            end;
                            if IsRecExistOrderEntry = false then begin
                                ExOrderEntry.Init();
                                ExOrderEntry."Order Date" := ExLunchMenu."Menu Date";
                                ExOrderEntry."Item Description" := ItemRec."Item Description";
                                ExOrderEntry."Menu Item Entry No." := ItemRec."Menu Item Entry No.";
                                ExOrderEntry."Menu Item No." := ItemRec."Item No.";
                                ExOrderEntry.Price := ItemRec.Price;
                                ExOrderEntry.Quantity := ItemRec."Order Quantity";
                                ExOrderEntry.Status := ExOrderEntry.Status::Created;
                                ExOrderEntry.Amount := ItemRec."Order Amount";
                                ExOrderEntry."Vendor No." := ItemRec."Vendor No.";
                                ExOrderEntry."Resource No." := UserId;
                                if IsNotEmpty then begin
                                    ExOrderEntryLoop.FindLast();
                                    ExOrderEntry."Entry No." := ExOrderEntryLoop."Entry No." + 1;
                                end else begin
                                    ExOrderEntry."Entry No." := ExOrderEntry."Entry No." + 1;
                                end;
                                ExOrderEntry.Insert();
                            end;
                        until ItemRec.Next() = 0;
                    end;
                end;
            until ExLunchMenu.Next() = 0;
        end;
    end;

    procedure ResetRecordQuantity();
    begin
        ExLunchMenu := Rec;
        ExLunchMenu.FindFirst();
        repeat
            ExLunchMenu."Order Quantity" := 0;
            ExLunchMenu."Order Amount" := 0;
            ExLunchMenu.Modify();
        until ExLunchMenu.Next() = 0;
    end;

    procedure GroupContol(var LunchMenuRecord: Record "Lunch Menu"): Text;
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

    procedure CheckActiveRec(var LunchMenuRecord: Record "Lunch Menu")
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

    procedure SumParams()
    var
        ExRecSum: Record "Lunch Menu";
        RecordGroup: Record "Lunch Menu";
        TotalItemsPrice: Decimal;
        TotalItemsWeight: Decimal;
        TotalQuantity: Decimal;
    begin
        ExRecSum := Rec;
        ExRecSum.SetCurrentKey("Line No.");
        if ExRecSum."Line Type" = ExRecSum."Line Type"::Group then begin
            RecordGroup := ExRecSum;
            ExRecSum.SetRange("Parent Menu Item Entry No.", RecordGroup."Menu Item Entry No.");
            ExRecSum."Order Quantity" := 0;
            repeat
                TotalItemsPrice := ExRecSum."Order Amount" + TotalItemsPrice;
                TotalItemsWeight := ExRecSum.Weight * ExRecSum."Order Quantity" + TotalItemsWeight;
                TotalQuantity := ExRecSum."Order Quantity" + TotalQuantity;
            until ExRecSum.Next() = 0;
            ExRecSum."Order Amount" := TotalItemsPrice;
            ExRecSum.Weight := TotalItemsWeight;
            ExRecSum."Order Quantity" := TotalQuantity;
            Rec."Order Amount" := ExRecSum."Order Amount";
            Rec.Weight := ExRecSum.Weight;
            Rec."Order Quantity" := ExRecSum."Order Quantity";
        end;
    end;

    procedure SetStyleStatusRec()
    begin
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