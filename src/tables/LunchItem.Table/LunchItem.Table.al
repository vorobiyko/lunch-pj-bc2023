table 60101 LunchItem
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Item Table';
    DrillDownPageID = "LunchItemList";
    LookupPageId = "LunchItemList";


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
            Subtype = Bitmap;
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
        field(9; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
    }

    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
    var
     NoSeriesManagement: Codeunit NoSeriesManagement;
     ItemSetup: Record "Item Setup";
    

    //  to initialize the number series.
    trigger OnInsert();
    begin
        if "Item No." = '' then begin
            ItemSetup.Get();
            ItemSetup.TestField("Item Nos.");
            // some damn thing with the starting data hard to understand the arguments
            NoSeriesManagement.InitSeries("ItemSetup"."Item Nos.",
                                        xRec."No. Series",
                                        0D,
                                        "Item No.",
                                        "No. Series");
        end;
    end;
    procedure AssistEdit(OldExample: Record LunchItem): Boolean
     var
         LunchItem: Record LunchItem;
     begin
         LunchItem := Rec;
         ItemSetup.Get();
         ItemSetup.TestField("Item Nos.");
         if NoSeriesManagement.SelectSeries(ItemSetup."Item Nos.",
                                         OldExample."No. Series",
                                         LunchItem."No. Series") then begin
             NoSeriesManagement.SetSeries(LunchItem."Item No.");
             Rec := LunchItem;
             exit(true);
         end;
     end;
}