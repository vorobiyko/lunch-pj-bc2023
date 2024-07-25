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
            DecimalPlaces = 0;
        }
        field(9; "Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price';
            DecimalPlaces = 1:2;
        }
        field(10; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount'; 
            DecimalPlaces = 1:2;
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
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Order Date"){}
        key(Key2; "Vendor No."){}
    }
    var LabelIsOrderSend: Label 'Order %1 was sent';
        LabelQuantityErr: Label 'Quantity must be field %1';
    internal procedure PostSelectedHandler(var SelectedRec: Record "Lunch Order Entry";
                                               ApiPage: Page "Vendor API")
    begin
        SelectedRec.FindFirst();
        repeat
            if (SelectedRec.Quantity <> 0) then begin
                if SelectedRec.Status= SelectedRec.Status::Created then begin
                    if ApiPage.PostVendorInfo(SelectedRec."Vendor No.",SelectedRec."Menu Item No.",SelectedRec.Quantity,SelectedRec."Order Date",SelectedRec."Menu Item Entry No.") then
                            SelectedRec.Status:= SelectedRec.Status::"Sent to Vendor";
                            SelectedRec.Modify();
                    end else begin
                        Message(LabelIsOrderSend, SelectedRec."Menu Item Entry No.");
                    end;  
                end else begin
            Message('Quantity must be field %1', SelectedRec."Menu Item Entry No.");
            end;
        until SelectedRec.Next()= 0;
    end; 
}