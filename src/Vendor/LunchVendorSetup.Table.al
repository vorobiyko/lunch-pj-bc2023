table 60105 "Vendor Setup"
 {
     Caption = 'Vendor Setup';
     DataClassification = CustomerContent;

     fields
     {
         field(1; "Primary Key"; Code[10])
         {
             Caption = 'Primary Key';
         }
          field(2; "Vendor Nos."; Code[20])
         {
             Caption = 'Vendor Nos.';
             TableRelation = "No. Series";
         }
     }
     keys
     {
         key(Key1; "Primary Key")
         {
             Clustered = true;
         }
     }
 }