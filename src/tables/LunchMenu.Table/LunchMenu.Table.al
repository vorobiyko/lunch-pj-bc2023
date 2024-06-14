table 60102 LunchMenu
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Menu Table';
    DrillDownPageID = LunchMenuEdit;
    LookupPageID = LunchMenuEdit;
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
            MinValue = 0;
            DecimalPlaces = 0;
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
        // field(14; "Previous Quantity"; Decimal)
        // {
        //     Caption = 'Previous Quantity';
        //     FieldClass = FlowField;
        //     MinValue = 0;
        // CalcFormula = Sum("LunchOrderEntry".Quantity WHERE ("Menu Item Entry No."=FIELD("Menu Item Entry No.")));
        // }
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

    trigger OnInsert()
    var
        ExRec: Record LunchMenu;
        IsGroupLine: Boolean;
    begin
        Rec.SetCurrentKey("Line No.");
        ExRec := Rec;
        IsGroupLine:= CheckGroupHandler;
        SetNewLineNo(IsGroupLine);
    end;
    trigger OnDelete()
    begin
        CurrRecEx := Rec;
        case Rec."Line Type" of
            Rec."Line Type"::"Group":
                begin
                    CurrRecEx.SetRange("Line No.",Rec."Line No.",Rec."Line No."+9999);
                    CurrRecEx.DeleteAll();
                end;
            else begin
                Delete();
            end;
        end;
       
    end;
    trigger OnModify()
    begin
        
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
                                exit;
                            until ExRecFunc.Next() = 0;
                    end;
                until ExRecLocal.Next()=0;
        end;
    end;
}