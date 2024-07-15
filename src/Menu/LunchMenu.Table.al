table 60102 "Lunch Menu"
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Menu';
    DrillDownPageID = "Lunch Menu View";
    LookupPageID = "Lunch Menu View";

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(2; "Menu Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Menu Date';
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = "Lunch Vendor";
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                Rec.Validate("Item No.", '');
            end;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = "Lunch Item" where("Vendor No." = field("Vendor No."));
            trigger OnValidate()
            var
                LunchItemEx: Record "Lunch Item";
            begin
                if LunchItemEx.Get("Item No.") then begin
                    Rec."Item Description" := LunchItemEx.Description;
                    Rec.Price := LunchItemEx.Price;
                    Rec.Weight := LunchItemEx.Weight;
                end else begin
                    Rec."Item Description" := '';
                    Rec.Price := 0;
                    Rec.Weight := 0;
                end;
            end;
        }
        field(5; "Item Description"; Text[250])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(6; "Weight"; Decimal)
        {
            Caption = 'Weight';
            DataClassification = CustomerContent;
        }
        field(7; "Price"; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }
        field(8; "Indentation"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Indentation';
            InitValue = 0;
        }
        field(9; "Menu Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Menu Item Entry No.';
            AutoIncrement = true;
        }
        field(10; Active; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
        }
        field(11; "Order Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Quantity';
            InitValue = 0;
            DecimalPlaces = 0;
            Editable = true;
        }
        field(12; "Order Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Amount';
        }
        field(13; "Line Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Type';
            OptionMembers = "Item","Group";
        }
        field(14; "Previous Quantity"; Decimal)
        {
            Caption = 'Previous Quantity';
            FieldClass = FlowField;
            MinValue = 0;
            CalcFormula = Sum("Lunch Order Entry".Quantity WHERE("Menu Item Entry No." = FIELD("Menu Item Entry No.")));
        }
        field(15; "Self-Order"; Boolean)
        {
            Caption = 'Self-Order';
            FieldClass = FlowField;
            CalcFormula = Lookup("Lunch Item"."Self-Order" WHERE("Item No." = FIELD("Item No.")));
        }
        field(16; "Parent Menu Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Parent Menu Item Entry No.';
        }
    }
    keys
    {
        key(PK; "Vendor No.", "Menu Date", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        CurrRecEx: Record "Lunch Menu";
        CurrConditionRec: Record "Lunch Menu";
        ExOrderEntryTable: Record "Lunch Order Entry";
        RecCurrOrderTable: Record "Lunch Order Entry";
        isAllowDeleteModify: Boolean;
        LabelIsSended: Label '%1 Sended to Vendor';

    trigger OnInsert()
    var ExRec: Record "Lunch Menu";
        IsGroupLine: Boolean;
    begin
        Rec.SetCurrentKey("Line No.");
        ExRec := Rec;
        IsGroupLine := CheckGroupHandler;
        SetNewLineNo(IsGroupLine);
        SetOrderAmountItem();
    end;

    trigger OnDelete()
    var RecLunchMenu: Record "Lunch Menu";
        RecOrderEnt: Record "Lunch Order Entry";
        HasSpyRec: Boolean;
        SpyRec: Record "Lunch Menu";
    begin
        RecLunchMenu := Rec;
        if RecLunchMenu.CheckGroupHandler() then begin
            //Group
            // Set Range and Choice Rec
            SetRangeGroup(RecLunchMenu, 1, 9999);
            RecLunchMenu.Next();
            // Checked has Rec how you want delete in OrderTable
            if not RecOrderEnt.IsEmpty then
                RecOrderEnt.FindFirst();
            repeat
                repeat
                    if ChekerDelModAllowedLunchMenu(RecLunchMenu, RecOrderEnt) then begin
                        // Allow to delete. Order is empty;
                        isAllowDeleteModify := true;
                    end else begin
                        //Order has Rec
                        isAllowDeleteModify := false;
                        break;
                    end;
                until RecOrderEnt.Next() = 0;
                if not isAllowDeleteModify then
                    break;
            until RecLunchMenu.Next() = 0;
            // Delete or Check More ->
            if isAllowDeleteModify then begin
                RecLunchMenu := Rec;
                SetRangeGroup(RecLunchMenu, 0, 9999);
                RecLunchMenu.DeleteAll();
                exit;
            end else begin
                // Check more ...
                RecLunchMenu.FindFirst();
                repeat
                    repeat
                        if CheckPermissionToDelModRecord(RecLunchMenu, RecOrderEnt) then begin
                            // delete
                            HasSpyRec := false;
                            CurrConditionRec := RecLunchMenu;
                            ExOrderEntryTable := RecOrderEnt;
                            SyncDelete(CurrConditionRec, ExOrderEntryTable);
                            break;
                        end else if RecLunchMenu."Menu Item Entry No." <> RecOrderEnt."Menu Item Entry No." then begin
                            // none
                            HasSpyRec := true;
                            SpyRec := RecLunchMenu;
                        end else begin
                            HasSpyRec := false;
                            break;
                        end;
                    until RecOrderEnt.Next() = 0;
                until RecLunchMenu.Next() = 0;
            end;
            // check spy rec
            FindNotSendedtoOrderRec(HasSpyRec, SpyRec);
            // Check if needed Group
            if RecLunchMenu.Count() > 0 then begin
                // Need Group
                AvoidDelete();
            end else begin
                // Needed delete Group
                Rec.Delete();
            end;
        end else begin
            // Item
            // If Rec in Orders
            DeleteItem(RecOrderEnt,RecLunchMenu);
            DeleteHandler();
        end;
    end;
    trigger OnModify()
    var RecLunchMenu: Record "Lunch Menu";
        RecOrderEnt: Record "Lunch Order Entry";
        SpyRec: Record "Lunch Menu";
        HasSpyRec: Boolean;

    begin
        CheckActiveRecord();
        SetOrderAmountItem();
        RecLunchMenu := Rec;
        if not RecOrderEnt.IsEmpty then
                RecOrderEnt.FindFirst();
        repeat
            if ChekerDelModAllowedLunchMenu(RecLunchMenu, RecOrderEnt) then begin
                // Allow to delete. Order is empty;
            end else begin
                //Order has Rec
                if CheckPermissionToDelModRecord(RecLunchMenu, RecOrderEnt) then begin
                    RecOrderEnt.Quantity := RecLunchMenu."Order Quantity";
                    RecOrderEnt.Amount:= RecLunchMenu."Order Amount";
                    RecOrderEnt.Modify();
                end else begin
                    Error(LabelIsSended, RecLunchMenu."Item No.");
                end;
                break;
            end;
        until RecOrderEnt.Next() = 0;
    end;
    local procedure DeleteItem(var RecOrderEnt: Record "Lunch Order Entry"; RecLunchMenu: Record "Lunch Menu")
    begin
        if not RecOrderEnt.IsEmpty then
                RecOrderEnt.FindFirst();
        repeat
            if ChekerDelModAllowedLunchMenu(RecLunchMenu, RecOrderEnt) then begin
                // Allow to delete. Order is empty;
                isAllowDeleteModify := true;
            end else begin
                //Order has Rec
                if CheckPermissionToDelModRecord(RecLunchMenu, RecOrderEnt) then begin
                    SyncDelete(RecLunchMenu, RecOrderEnt);
                    isAllowDeleteModify := false;
                end else begin
                    Message(LabelIsSended, RecLunchMenu."Item No.");
                    isAllowDeleteModify := false;
                end;
                break;
            end;
        until RecOrderEnt.Next() = 0;
    end;
    local procedure DeleteHandler()
    begin
        if isAllowDeleteModify then begin
            Rec.Delete();
        end else begin
            AvoidDelete();
        end;
    end;
    
    local procedure FindNotSendedtoOrderRec(var HasSpyRec: Boolean; SpyRec: Record "Lunch Menu")
    begin
        if (HasSpyRec) AND (SpyRec.Count > 0) then
            SpyRec.Delete();
    end;
    local procedure CheckActiveRecord()
    begin
        if Rec.CheckGroupHandler() then begin
            CurrRecEx := Rec;
            CurrRecEx.SetRangeGroup(CurrRecEx, 1, 9999);
            if CurrRecEx.FindFirst() then begin
                repeat
                    CurrRecEx."Menu Date" := Rec."Menu Date";
                    CurrRecEx.Active := Rec.Active;
                    CurrRecEx.Modify();
                until CurrRecEx.Next() = 0;
            end;
        end;
    end;
    local procedure CheckPermissionToDelModRecord(var CheckLunnchMenu: Record "Lunch Menu"; 
                                                      CheckOrder: Record "Lunch Order Entry"): Boolean;
    begin
        if (CheckLunnchMenu."Menu Item Entry No." = CheckOrder."Menu Item Entry No.") and (CheckOrder.Status = CheckOrder.Status::Created) then begin
            // allow delete;
            exit(true);
        end else begin
            // No delete;
            exit(false);
        end;
    end;
    local procedure ChekerDelModAllowedLunchMenu(var CheckLunnchMenu: Record "Lunch Menu";
                                                     CheckOrder: Record "Lunch Order Entry"): Boolean;
    begin
        if (CheckLunnchMenu."Menu Item Entry No." = CheckOrder."Menu Item Entry No.") then begin
            exit(false);
        end else if CheckOrder.IsEmpty then begin
            exit(true);
        end else begin
            exit(true);
            // I Order not Rec/ you can delete modify
        end;
    end;
    local procedure SetNewLineNo(var isGroup: Boolean)
    var ExRecLocal: Record "Lunch Menu";
        ExRecFunc: Record "Lunch Menu";
        CurrentGroupLineNo: Integer;
    begin
        ExRecLocal := Rec;
        ExRecLocal.SetCurrentKey("Line No.");
        if isGroup then begin
            SetLineNoGroup(ExRecLocal);
        end else begin
            repeat
                if Rec."Parent Menu Item Entry No." = ExRecLocal."Menu Item Entry No." then begin
                    SetLineNoItem(CurrentGroupLineNo,ExRecLocal,ExRecFunc);
                end;
            until ExRecLocal.Next() = 0;
        end;
    end;
    local procedure SetLineNoItem(var CurrentGroupLineNo: Integer;
                                      ExRecLocal: Record "Lunch Menu";
                                      ExRecFunc: Record "Lunch Menu")
    begin
        CurrentGroupLineNo := ExRecLocal."Line No.";
        ExRecFunc := ExRecLocal;
        ExRecFunc.SetCurrentKey("Line No.");
        ExRecFunc.SetRange("Line No.", CurrentGroupLineNo, ExRecLocal."Line No." + 9999);
        if ExRecFunc.FindLast() then begin
            repeat
                Rec."Line No." := ExRecFunc."Line No." + 1;
                Rec.Indentation := 1;
                Rec."Menu Date" := ExRecFunc."Menu Date";
                Rec.Active := ExRecFunc.Active;
                exit;
            until ExRecFunc.Next() = 0;
        end;
    end;
    local procedure SetLineNoGroup(var ExRecLocal: Record "Lunch Menu")
    begin
        ExRecLocal.SetRange("Line Type", "Line Type"::Group);
        if ExRecLocal.FindLast() then begin
            repeat
                Rec."Line No." := ExRecLocal."Line No." + 10000;
                Rec.Indentation := 0;
            until ExRecLocal.Next() = 0;
        end; 
    end;
    local procedure SyncDelete(var RecMainTable: Record "Lunch Menu";
                                   RecDependTable: Record "Lunch Order Entry")
    begin
        RecMainTable.Delete();
        RecDependTable.Delete();
    end;
    local procedure AvoidDelete()
    begin
        Rec.Init();
        Rec."Line No." := 10000 * Rec.Count();
        Rec.Insert();
    end;
    local procedure SetOrderAmountItem()
    begin
        Rec."Order Amount" := Rec."Order Quantity" * Rec.Price;
    end;
    
    local procedure SetValue(var ExOrderEntry: Record "Lunch Order Entry";
                                 ExLunchMenu: Record "Lunch Menu";
                                 ExOrderEntryLoop: Record "Lunch Order Entry";
                                 IsNotEmpty: Boolean)
    begin
        ExOrderEntry.Init();
        ExOrderEntry."Order Date" := ExLunchMenu."Menu Date";
        ExOrderEntry."Item Description" := ExLunchMenu."Item Description";
        ExOrderEntry."Menu Item Entry No." := ExLunchMenu."Menu Item Entry No.";
        ExOrderEntry."Menu Item No." := ExLunchMenu."Item No.";
        ExOrderEntry.Price := ExLunchMenu.Price;
        ExOrderEntry.Quantity := ExLunchMenu."Order Quantity";
        ExOrderEntry.Status := ExOrderEntry.Status::Created;
        ExOrderEntry."Vendor No." := ExLunchMenu."Vendor No.";
        ExOrderEntry."Resource No." := UserId;
        ExOrderEntry.Amount:= ExLunchMenu."Order Amount";
        if IsNotEmpty then begin
            ExOrderEntryLoop.FindLast();
            ExOrderEntry."Entry No." := ExOrderEntryLoop."Entry No." + 1;
        end else begin
            ExOrderEntry."Entry No." := ExOrderEntry."Entry No." + 1;
        end;
        ExOrderEntry.Insert();
    end;
    internal procedure CheckGroupHandler(): Boolean;
    var isGroup: Boolean;
    begin
        CurrRecEx := Rec;
        if (CurrRecEx."Line Type" = CurrRecEx."Line Type"::Group) then begin
            isGroup := true;
        end else begin
            isGroup := false;
        end;
        exit(isGroup);
    end;
    internal procedure SetRangeGroup(var RecordGroup: Record "Lunch Menu";
                                         MoveStep: Integer;
                                         GroupSize: Integer)
    begin
        RecordGroup.SetCurrentKey("Line No.");
        RecordGroup.SetRange("Line No.", "Line No." + MoveStep, "Line No." + GroupSize);
    end;
    internal procedure SumParams()
    var ExRecSum: Record "Lunch Menu";
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
    internal procedure ResetRecordQuantity(var ExLunchMenu: Record "Lunch Menu");
    begin
        ExLunchMenu := Rec;
        ExLunchMenu.FindFirst();
        repeat
            ExLunchMenu."Order Quantity" := 0;
            ExLunchMenu."Order Amount" := 0;
            ExLunchMenu.Modify();
        until ExLunchMenu.Next() = 0;
    end;
    internal procedure AddRecordToOrder(var ExOrderEntry: Record "Lunch Order Entry";
                                            ExOrderEntryLoop: Record "Lunch Order Entry";
                                            IsNotEmpty: Boolean;
                                            ExLunchMenu: Record "Lunch Menu";
                                            IsRecExistOrderEntry: Boolean)
    begin
        if ExOrderEntry.IsEmpty then begin
            IsNotEmpty := false;
        end else begin
            IsNotEmpty := true;
        end;
        if Dialog.Confirm('Send Menu Items to Create Order?') then begin
            ExLunchMenu.SetCurrentKey("Line No.");
            ExLunchMenu.Next();
            ExOrderEntryLoop.SetCurrentKey("Entry No.");
            repeat
                if ExLunchMenu.CheckGroupHandler() = false then begin
                    if IsNotEmpty then begin
                        if IsRecExistOrderEntry then begin
                            IsRecExistOrderEntry := false;
                        end;
                        if (ExOrderEntryLoop.FindSet()) then begin
                            repeat
                                if ((ExLunchMenu."Menu Item Entry No." = ExOrderEntryLoop."Menu Item Entry No.")) then begin
                                    IsRecExistOrderEntry := true;
                                        break;
                                end;
                            until ExOrderEntryLoop.Next() = 0;
                        end;
                    end;
                    if ExLunchMenu.Active = false then begin
                        IsRecExistOrderEntry := true;
                    end;
                    if IsRecExistOrderEntry = false then begin
                        SetValue(ExOrderEntry,ExLunchMenu,ExOrderEntryLoop,IsNotEmpty);
                        IsNotEmpty := true;
                    end;
                end;
            until ExLunchMenu.Next() = 0;
        end;
    end;    
}