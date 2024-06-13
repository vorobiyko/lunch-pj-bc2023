table 60222 LunchMenuSystem
{
    DataClassification = CustomerContent;
    fields
    {
        field(1;"Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Parent Menu Item Entry No."; Integer)
        {
            DataClassification = CustomerContent;        
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }      
}