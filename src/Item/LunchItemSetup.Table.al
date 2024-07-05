table 60121 "Item Setup"
 {
     Caption = 'Item Setup';
     DataClassification = CustomerContent;

     fields
     {
         field(1; "Primary Key"; Code[10])
         {
             Caption = 'Primary Key';
         }
          field(2; "Item Nos."; Code[20])
         {
             Caption = 'Item Nos.';
             TableRelation = "No. Series";
         }
     }
     keys
     {
         key(PK; "Primary Key")
         {
             Clustered = true;
         }
     }
 }