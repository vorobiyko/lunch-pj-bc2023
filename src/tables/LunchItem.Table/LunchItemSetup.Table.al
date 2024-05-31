table 60121 "Item Setup"
 {
     Caption = 'item Setup';
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
         key(Key1; "Primary Key")
         {
             Clustered = true;
         }
     }
 }