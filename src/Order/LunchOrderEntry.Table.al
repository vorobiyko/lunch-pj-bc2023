table 60103 "Lunch Order Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Order Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Order Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Date';
        }
        field(3; "Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource No.';
        }
        field(4; "Menu Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Menu Item Entry No.';
        }
        field(5; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(6; "Menu Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Menu Item No.';
        }
        field(7; "Item Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Description';
        }
        field(8; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(9; "Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price';
        }
        field(10; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(11; Status; Option)
        {
            OptionMembers = "Created","Sent to Vendor","Posted";
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "Order Date", "Vendor No.", "Entry No.")
        {
            Clustered = true;
        }
        // key()
        // {

        // }
    }
}