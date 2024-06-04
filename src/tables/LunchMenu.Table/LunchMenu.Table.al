table 60102 LunchMenu
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Menu Table';
    DrillDownPageID = LunchMenuEdit;
    LookupPageID = LunchMenuEdit;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            TableRelation = LunchVendorTable;
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                Rec.Validate("Item No.", '');
            end;

            // FieldClass = FlowField;
            // CalcFormula = Lookup("LunchItem"."Vendor No." WHERE ("Item No."=FIELD("Item No.")));
        }
        field(2; "Menu Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Menu Date';

        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';

        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = LunchItem where("Vendor No." = field("Vendor No."));
            trigger OnValidate()
            var
                LunchItemState: Record LunchItem;
            begin
                if LunchItemState.Get("Item No.") then begin
                    Rec."Item Description" := LunchItemState.Description;
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
            OptionMembers = "Item","Group","Heading";
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
            trigger OnLookup()
            var
                Menu: record LunchMenu;
            begin
                if Page.RunModal(0, Menu) = Action::LookupOK then begin
                    Rec."Parent Menu Item Entry No." := Menu."Menu Item Entry No.";
                end;
            end;
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
    RecRef: RecordRef;
    RecID: RecordID;
    varTableNumber: Integer;
    Text000: Label 'The primary key is: %1.';
    varPrimaryKey: Text;
    // trigger OnModify()
    // begin
    //      Message('OnModify TABLE %1', Rec.SystemId);
    // end;
//     trigger OnInsert()
//     begin
//         Message('OnInsert TABLE');
        

//     end;

    

//     trigger OnRename()
//     begin
//         Message('OnRename TABLE');
//     end;



}