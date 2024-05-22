table 60101 LunchItem
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Item Table';
    DataCaptionFields = "Vendor No.", "Item No.";
    DrillDownPageID = "LunchItemList";


    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            // Link the field to the Vendor table
            TableRelation = LunchVendorTable;
            NotBlank = true;
        
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            NotBlank = true;
        }
        field(3; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(4; Weight; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight';
            MinValue = 0;
        }
        field(5; Price; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price';
        }
        field(6; Picture; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture';
        }
        field(7; "Info Link"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Info Link';
        }
        field(8; "Self-Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = ' Self-Order';
        }
    }

    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
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