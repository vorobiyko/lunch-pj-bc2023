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
                end else begin
                    Rec."Item Description" := '';
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
            FieldClass = FlowField;
            CalcFormula = Lookup("LunchItem".Weight WHERE("Item No." = FIELD("Item No.")));
        }
        field(7; "Price"; Decimal)
        {
            Caption = 'Price';
            FieldClass = FlowField;
            CalcFormula = Lookup("LunchItem".Price WHERE("Item No." = FIELD("Item No.")));
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
        ListLineNoValues: List of [Integer];
        LineNoValue: Integer;
        BufferRecTable: Record "LunchMenuSystem";
        IndentationItem: Integer;

    trigger OnInsert()
    var
        ExRec: Record LunchMenu;
        i: Integer;
    begin
        ExRec := Rec;
        if CheckGroupHandler then begin
            ResetValuesListHandler(ListLineNoValues);
            BufferRecTable.DeleteAll();
            if (ExRec."Parent Menu Item Entry No." = 0) then begin
                ListLineNoValues:= SortList(ListLineNoValues, ExRec);
                ListLineNoValues.Reverse();
                Rec."Line No." := ListLineNoValues.Get(1) + 10000;
                SetBufferValueHandler(Rec);
            end;
        end else begin
            if BufferRecTable.FindLast() then begin
                IndentationItem:= 1;
                repeat
                    Rec."Line No." := BufferRecTable."Line No." + 1;
                    Rec.Indentation:= IndentationItem;
                    SetBufferValueHandler(Rec);
                until BufferRecTable.Next() = 0;
            end;

        end;
    end;

    trigger OnModify()
    begin
        CurrRecEx := Rec;
        CurrRecEx.SetRange("Line No.", CurrRecEx."Line No.", CurrRecEx."Line No." + 9999);
        BufferRecTable.DeleteAll(); 
        // mb bug no delete All;
        if CurrRecEx.FindLast() then begin
            repeat
                SetBufferValueHandler(CurrRecEx);
            until CurrRecEx.Next() = 0;
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

    procedure ResetValuesListHandler(var CheckList: List of [Integer])
    begin
        if CheckList.Count > 0 then begin
                CheckList.RemoveRange(0, CheckList.Count);
            end;
    end;
    procedure SetBufferValueHandler(var RecordEx: Record LunchMenu)
    begin
        BufferRecTable."Line No." := RecordEx."Line No.";
        BufferRecTable.Insert();
    end;
    procedure SortList (var SortedList: List of [Integer]; ExRec: Record LunchMenu): List of [Integer];
        var ListCount, ShuffleEl, i, k: Integer;
    begin
        
            repeat
                if (ExRec."Line Type" <> ExRec."Line Type"::Item) then begin
                    SortedList.Add(ExRec."Line No.");
                end;
            until ExRec.Next() = 0;
    
            ListCount:= SortedList.Count;

           
            if (ListCount<0) then begin
                SortedList.Add(0);
            end else begin
                for k := 2 to ListCount+1 do  
                    for i := 1 to ListCount+1-k do  
                        if SortedList.Get(i)>SortedList.Get(i+1) then begin
                            ShuffleEl:= ListLineNoValues.Get(i);
                            SortedList.Set(i, ListLineNoValues.Get(i+1), ShuffleEl);
                            SortedList.Set(i+1, ShuffleEl);
                        end;
            end;
            exit(SortedList)
            
    end;
}



// PAGE NEED ONLY FOR TEST
page 60222 PageName
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LunchMenuSystem;
    Caption = 'LunchMenuSystem';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;

                }
                field("Parent Menu Item Entry No."; Rec."Parent Menu Item Entry No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}