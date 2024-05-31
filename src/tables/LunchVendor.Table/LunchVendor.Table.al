table 60104 LunchVendorTable
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Vendor Table';
    DrillDownPageID = "LunchVendorList";
    LookupPageID = "LunchVendorList";

    fields
    {
        field(1; "Vendor No."; Code[20])
        {   
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';

        }
     
        field(2; Company; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Company';
        }
        field(3; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
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
        fieldgroup(DropDown; "Vendor No.", Company)
        {
            // Custom fields for DropDown Table
        }
    }

    var
     NoSeriesManagement: Codeunit NoSeriesManagement;
     VendorSetup: Record "Vendor Setup";
    

    //  to initialize the number series.
    trigger OnInsert();
    begin
        if "Vendor No." = '' then begin
            VendorSetup.Get();
            VendorSetup.TestField("Vendor Nos.");
            // some damn thing with the starting data hard to understand the arguments
            NoSeriesManagement.InitSeries("VendorSetup"."Vendor Nos.",
                                        xRec."No. Series",
                                        0D,
                                        "Vendor No.",
                                        "No. Series");
        end;
    end;
    procedure AssistEdit(OldExample: Record LunchVendorTable): Boolean
     var
         LunchVendorTable: Record LunchVendorTable;
     begin
         LunchVendorTable := Rec;
         VendorSetup.Get();
         VendorSetup.TestField("Vendor Nos.");
         if NoSeriesManagement.SelectSeries(VendorSetup."Vendor Nos.",
                                         OldExample."No. Series",
                                         LunchVendorTable."No. Series") then begin
             NoSeriesManagement.SetSeries(LunchVendorTable."Vendor No.");
             Rec := LunchVendorTable;
             exit(true);
         end;
     end;
}