    page 60125 LunchVendorSetupCard
{
    ApplicationArea = All;
    Caption = 'Lunch Vendor Setup Card';
    PageType = Card;
    SourceTable = "Vendor Setup";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vendor Nos."; Rec."Vendor Nos.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;
}