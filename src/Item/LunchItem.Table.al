table 60101 "Lunch Item"
{
    DataClassification = CustomerContent;
    Caption = 'Lunch Item';
    DrillDownPageID = "Lunch Item List View";
    LookupPageId = "Lunch Item List View";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            NotBlank = true;
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            TableRelation = "Lunch Vendor";
            NotBlank = true;
        }
        field(3; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            NotBlank = true;
        }
        field(4; Weight; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight';
            MinValue = 0;
            DecimalPlaces = 1:2;
        }
        field(5; Price; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price';
            DecimalPlaces = 1:2;
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
            NotBlank = true;
        }
        field(10; Media; Media)
        {
        }
    }

    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
     fieldgroups
    {
        fieldgroup(Brick; "Item No.", Description, "Vendor No.", Media, Price, Weight)
        {
            
        }
    }
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ItemSetup: Record "Item Setup";


    //  to initialize the number series.
    trigger OnInsert();
    var
        BlobObj: InStream;
    begin
        if "Item No." = '' then begin
            ItemSetup.Get();
            ItemSetup.TestField("Item Nos.");
            NoSeriesManagement.InitSeries("ItemSetup"."Item Nos.",xRec."No. Series",0D,"Item No.","No. Series");
        end;
        Rec.Picture.CreateInStream(BlobObj);
        if BlobObj.Length > 0 then
            Rec.Media.ImportStream(BlobObj, 'Demo image for item');
    end;
    
    trigger OnModify()
    var
        BlobObj: InStream;
    begin
        Rec.Picture.CreateInStream(BlobObj);
        if BlobObj.Length > 0 then
            Rec.Media.ImportStream(BlobObj, 'Demo image for item');
    end;

    internal procedure AssistEdit(OldExample: Record "Lunch Item"): Boolean
    var
        "Lunch Item": Record "Lunch Item";
    begin
        "Lunch Item" := Rec;
        ItemSetup.Get();
        ItemSetup.TestField("Item Nos.");
        if NoSeriesManagement.SelectSeries(ItemSetup."Item Nos.",OldExample."No. Series","Lunch Item"."No. Series") then begin
            NoSeriesManagement.SetSeries("Lunch Item"."Item No.");
            Rec := "Lunch Item";
            exit(true);
        end;
    end;
}