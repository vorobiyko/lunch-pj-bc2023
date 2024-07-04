table 60102 LunchMenu
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Menu Table';
    DrillDownPageID = LunchOrder;
    LookupPageID = LunchOrder;

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
            TableRelation = LunchVendorTable;
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
            TableRelation = LunchItem where("Vendor No." = field("Vendor No."));
            trigger OnValidate()
            var
                LunchItemEx: Record LunchItem;
            begin
                if LunchItemEx.Get("Item No.") then begin
                    Rec."Item Description" := LunchItemEx.Description;
                    Rec.Price:= LunchItemEx.Price;
                    Rec.Weight:= LunchItemEx.Weight;
                end else begin
                    Rec."Item Description" := '';
                    Rec.Price:= 0;
                    Rec.Weight:= 0;
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
            OptionMembers = "Item", "Group";
        }
        field(14; "Previous Quantity"; Decimal)
        {
            Caption = 'Previous Quantity';
            FieldClass = FlowField;
            MinValue = 0;
            CalcFormula = Sum("LunchOrderEntry".Quantity WHERE ("Menu Item Entry No."=FIELD("Menu Item Entry No.")));
        }
        field(15; "Self-Order"; Boolean)
        {
            Caption = 'Self-Order';
            FieldClass = FlowField;
            CalcFormula = Lookup("LunchItem"."Self-Order" WHERE("Item No." = FIELD("Item No.")));
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
        CurrRecEx: Record LunchMenu;
        CurrConditionRec: Record LunchMenu;
        ExOrderEntryTable: Record LunchOrderEntry;
        RecCurrOrderTable: Record LunchOrderEntry;
        isAllowDeleteModify: Boolean;
    trigger OnInsert()
    var
        ExRec: Record LunchMenu;
        IsGroupLine: Boolean;
    begin
        Rec.SetCurrentKey("Line No.");
        ExRec := Rec;
        IsGroupLine:= CheckGroupHandler;
        SetNewLineNo(IsGroupLine);
        SetOrderAmountItem();
    end;
    trigger OnDelete()
    var RecLunchMenu: Record LunchMenu;
        RecOrderEnt: Record LunchOrderEntry;
        HasSpyRec: Boolean;
        SpyRec: Record LunchMenu;
    begin
        RecLunchMenu:= Rec;
        if RecLunchMenu.CheckGroupHandler() then begin
            //Group
            // Set Range and Choice Rec
            SetRangeGroup(RecLunchMenu, 1, 9999);
            RecLunchMenu.Next();
            // Checked has Rec how you want delete in OrderTable
            CheckDependTableIfEmpty(RecOrderEnt); 
            repeat
                repeat
                    if ChekerDelModAllowedLunchMenu(RecLunchMenu,RecOrderEnt) then begin
                        // Allow to delete. Order is empty;
                        isAllowDeleteModify:= true;
                    end else begin
                        //Order has Rec
                        isAllowDeleteModify:=false;
                        break;
                    end;
                until RecOrderEnt.Next()=0;
                if not isAllowDeleteModify then
                    break; 
            until RecLunchMenu.Next()=0;
            // Delete or Check More ->
            if isAllowDeleteModify then begin
                RecLunchMenu:= Rec;
                SetRangeGroup(RecLunchMenu, 0, 9999);
                RecLunchMenu.DeleteAll();
                exit;
            end else begin
                // Check more ...
                RecLunchMenu.FindFirst();
                RecOrderEnt.FindFirst();
                repeat
                    repeat
                        if CheckPermissionToDelModRecord(RecLunchMenu,RecOrderEnt) then begin
                            // delete
                            HasSpyRec:= false;
                            CurrConditionRec:= RecLunchMenu;
                            ExOrderEntryTable:=RecOrderEnt;
                            SyncDelete(CurrConditionRec,ExOrderEntryTable);
                            break;
                        end else if RecLunchMenu."Menu Item Entry No." <> RecOrderEnt."Menu Item Entry No." then begin
                            // none
                            HasSpyRec:=true;
                            SpyRec:= RecLunchMenu;
                        end else begin
                            HasSpyRec:=false;
                            break;
                        end;
                    until RecOrderEnt.Next() = 0;
                until RecLunchMenu.Next() = 0;
            end;
            // check spy rec
            if (HasSpyRec) AND (SpyRec.Count>0) then
                SpyRec.Delete();

            // Check if needed Group
            if RecLunchMenu.Count()>0 then begin
                // Need Group
                AvoidDelete();   
            end else begin
                // Needed delete Group
                Rec.Delete();
            end;;
        end else begin
            // Item
            // If Rec in Orders
            CheckDependTableIfEmpty(RecOrderEnt); 
            repeat
                if ChekerDelModAllowedLunchMenu(RecLunchMenu,RecOrderEnt) then begin
                    // Allow to delete. Order is empty;
                        isAllowDeleteModify:=true;
                    end else begin
                    //Order has Rec
                        if CheckPermissionToDelModRecord(RecLunchMenu,RecOrderEnt) then begin
                            SyncDelete(RecLunchMenu,RecOrderEnt);
                            isAllowDeleteModify:=false;
                        end else begin
                            Message('%1 Sended to Vendor', RecLunchMenu."Item No.");
                            isAllowDeleteModify:=false;
                        end;
                        break;
                    end;
            until RecOrderEnt.Next()=0;
            if isAllowDeleteModify then begin
                Rec.Delete();
            end else begin
                AvoidDelete();
            end;
 
        end;
    end;
    trigger OnModify()
    var RecLunchMenu: Record LunchMenu;
        RecOrderEnt: Record LunchOrderEntry;
        SpyRec: Record LunchMenu;
        HasSpyRec: Boolean;
        
    begin
        CheckActiveRec();
        SetOrderAmountItem();
        RecLunchMenu:= Rec;
        CheckDependTableIfEmpty(RecOrderEnt); 
            repeat
                if ChekerDelModAllowedLunchMenu(RecLunchMenu,RecOrderEnt) then begin
                    // Allow to delete. Order is empty;
                    end else begin
                    //Order has Rec
                        if CheckPermissionToDelModRecord(RecLunchMenu,RecOrderEnt) then begin
                            RecOrderEnt.Quantity:= RecLunchMenu."Order Quantity";
                            RecOrderEnt.Modify();
                        end else begin
                            Message('%1 Sended to Vendor', RecLunchMenu."Item No.");
                        end;
                        break;
                    end;
            until RecOrderEnt.Next()=0;
    end;
    procedure CheckActiveRec()
    begin
        if Rec.CheckGroupHandler() then begin
            CurrRecEx:= Rec;
            CurrRecEx.SetRangeGroup(CurrRecEx, 1, 9999);
            if CurrRecEx.FindFirst() then begin
                repeat
                    CurrRecEx."Menu Date":= Rec."Menu Date";
                    CurrRecEx.Active:= Rec.Active;
                    CurrRecEx.Modify();
             until CurrRecEx.Next()=0;
            end;
        end;
        
    end;
    procedure CheckPermissionToDelModRecord(var CheckLunnchMenu: Record LunchMenu; var CheckOrder: Record LunchOrderEntry ):Boolean;
    begin
        if (CheckLunnchMenu."Menu Item Entry No."=CheckOrder."Menu Item Entry No.") and (CheckOrder.Status=CheckOrder.Status::Created) then begin
            // allow delete;
            exit(true);
        end else begin
            // No delete;
            exit(false);
        end;
    end;

    procedure ChekerDelModAllowedLunchMenu(var CheckLunnchMenu: Record LunchMenu; var CheckOrder: Record LunchOrderEntry ):Boolean;
    begin
        if (CheckLunnchMenu."Menu Item Entry No." = CheckOrder."Menu Item Entry No.")  then begin
            exit(false);
        end else if CheckOrder.IsEmpty then begin
            exit(true);
        end else begin
            exit (true); 
            // I Order not Rec/ you can delete modify
        end;
    end;

    
    procedure CheckGroupHandler(): Boolean;
    var
        isGroup: Boolean;
    begin
        CurrRecEx := Rec;
        if (CurrRecEx."Line Type" = CurrRecEx."Line Type"::Group) then begin
            isGroup := true;
        end else begin
            isGroup := false;
        end;
        exit(isGroup);
    end;

    procedure SetNewLineNo(var isGroup: Boolean)
    var ExRecLocal: Record LunchMenu;
        ExRecFunc: Record LunchMenu;
        CurrentGroupLineNo: Integer;
    begin
        ExRecLocal:= Rec;
        ExRecLocal.SetCurrentKey("Line No.");
        if isGroup then begin
            ExRecLocal.SetRange("Line Type", "Line Type"::Group);
            if ExRecLocal.FindLast() then 
                repeat
                    Rec."Line No.":= ExRecLocal."Line No."+10000;
                    Rec.Indentation:= 0;
                until ExRecLocal.Next() = 0;   
        end else begin
                repeat
                    if Rec."Parent Menu Item Entry No." = ExRecLocal."Menu Item Entry No." then begin
                        CurrentGroupLineNo:= ExRecLocal."Line No.";
                        ExRecFunc:= ExRecLocal;
                        ExRecFunc.SetCurrentKey("Line No.");
                        ExRecFunc.SetRange("Line No.",CurrentGroupLineNo,ExRecLocal."Line No."+9999);
                        if ExRecFunc.FindLast() then
                            repeat
                                Rec."Line No.":= ExRecFunc."Line No."+1;
                                Rec.Indentation:= 1;
                                Rec."Menu Date":= ExRecFunc."Menu Date";
                                Rec.Active:= ExRecFunc.Active;
                                exit;
                            until ExRecFunc.Next() = 0;
                    end;
                until ExRecLocal.Next()=0;
        end;
    end;
    procedure SetRangeGroup(var RecordGroup: Record LunchMenu; MoveStep: Integer; GroupSize: Integer)
    begin
        RecordGroup.SetCurrentKey("Line No.");
        RecordGroup.SetRange("Line No.", "Line No."+MoveStep, "Line No."+GroupSize);
    end;
    procedure SyncDelete(var RecMainTable: Record LunchMenu; RecDependTable: Record LunchOrderEntry)
    begin
        RecMainTable.Delete();
        RecDependTable.Delete();
    end;
    procedure AvoidDelete()
    begin
        Rec.Init();
        Rec."Line No.":= 10000*Rec.Count();
        Rec.Insert();
    end;
    procedure CheckDependTableIfEmpty(var CheckedDependTable: Record LunchOrderEntry)
    begin
        if not CheckedDependTable.FindFirst() then begin
                Message('Have not orders');
        end;
    end;
    procedure SetOrderAmountItem()
    begin
        Rec."Order Amount":= Rec."Order Quantity"*Rec.Price;
    end;

}