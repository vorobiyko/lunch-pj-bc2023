table 60102 LunchMenu
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Menu Table';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            TableRelation = LunchVendorTable."Vendor No.";
            // Link to Vendor table
            NotBlank = true;
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
            TableRelation = LunchItem;
            NotBlank = true;
        }
        field(5; "Item Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description';
        }
        field(6; "Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight';
            MinValue = 0;
        }
        field(7; "Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price';
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
        field(14; "Previous Quantity"; Decimal)
        {
            Caption = 'Previous Quantity';
            FieldClass = FlowField;
            MinValue = 0;
            // CalcFormula = Sum("LunchOrderEntry".Quantity WHERE ("Menu Item Entry No."=FIELD("Menu Item Entry No.")));
        }
        field(15; "Self-Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Self-Order';
        }
        field(16; "Parent Menu Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Parent Menu Item Entry No.';
        }
    }

    keys
    {
        key(PK; "Vendor No.")
        {
            Clustered = true;
        }
        key(MenuDateKey; "Menu Date")
        {

        }
        key(LineNoKey; "Line No.")
        {

        }
    }

    // fieldgroups
    // {
    //     // Add changes to field groups here
    // }

    // var
    //     myInt: Integer;

    // trigger OnInsert()
    // begin

    // end;

    // trigger OnModify()
    // begin

    // end;

    // trigger OnDelete()
    // begin

    // end;

    // trigger OnRename()
    // begin

    // end;

}