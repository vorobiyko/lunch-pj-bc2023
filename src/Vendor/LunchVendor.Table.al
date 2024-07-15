table 60104 "Lunch Vendor"
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Vendor';
    DrillDownPageID = "Lunch Vendor View";
    LookupPageID = "Lunch Vendor View";

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
            NoSeriesManagement.InitSeries("VendorSetup"."Vendor Nos.",
                                        xRec."No. Series",
                                        0D,
                                        "Vendor No.",
                                        "No. Series");
        end;
    end;

    internal procedure AssistEdit(OldExample: Record "Lunch Vendor"): Boolean
    var
        "Lunch Vendor": Record "Lunch Vendor";
    begin
        "Lunch Vendor" := Rec;
        VendorSetup.Get();
        VendorSetup.TestField("Vendor Nos.");
        if NoSeriesManagement.SelectSeries(VendorSetup."Vendor Nos.",
                                        OldExample."No. Series",
                                        "Lunch Vendor"."No. Series") then begin
            NoSeriesManagement.SetSeries("Lunch Vendor"."Vendor No.");
            Rec := "Lunch Vendor";
            exit(true);
        end;
    end;
}