page 60122 "Lunch Item List View"

{
    PageType = List;
    UsageCategory = Lists;
    Caption = 'Lunch Item List';
    SourceTable = "Lunch Item";
    CardPageId = "Lunch Item Creater";
    Editable = false;
    ApplicationArea = All;

    
    layout
    {
        
        
        area(Content)
        {
            
            
            
            repeater("Lunch Item")
            {
                field("Vendor No."; Rec."Vendor No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Description"; Rec."Description") { }
                field("Weight"; Rec."Weight") { }
                field("Price"; Rec.Price) { }
                field("Picture"; Rec.Picture) { }
                field("Info Link"; Rec."Info Link") { }
                field("Self-Order"; Rec."Self-Order") { }
            }
            usercontrol(Name; MyControlAddIn){
                
            }
        }
        
    }
}
controladdin MyControlAddIn
        {
            MaximumWidth = 0;
             Scripts = 'src\Item\test.js';
            
            // StyleSheets = 'src\Item\style.css';
        }