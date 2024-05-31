page 60122 LunchItemList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Lunch Item List Page';
    SourceTable = LunchItem;
    CardPageId = "LunchItemCard";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Lunch Item")
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Weight"; Rec."Weight")
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field("Picture"; Rec.Picture)
                {
                    ApplicationArea = All;
                }
                field("Info Link"; Rec."Info Link")
                {
                    ApplicationArea = All;
                }
                field("Self-Order"; Rec."Self-Order")
                {
                    ApplicationArea = All;
                }
            }
        }
        // area(Factboxes)
        // {

        // }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }
}