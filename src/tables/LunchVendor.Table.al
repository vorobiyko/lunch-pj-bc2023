table 60104 LunchVendorTable
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Vendor Table';
    // DataCaptionFields = "Vendor No.", Company;
    DrillDownPageID = "LunchVendorList";
    LookupPageID = "LunchVendorList";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            NotBlank = true;
            // Editable = false;

        }
        field(2; Company; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Company';
        }

    }

    keys
    {
        key(PK; "Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
       fieldgroup(DropDown; "Vendor No.",Company){
        // Custom fields for DropDown Table
       }
    }

    var
        myInt: Integer;

   trigger OnInsert()
    var
       Counter: Integer;
    begin
        Message('Inseert');
        if Rec."Vendor No." = '' then
        begin
            Counter :=+ 1; 
            Rec."Vendor No." := Format('00000', Counter);
        end;
    end;

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
