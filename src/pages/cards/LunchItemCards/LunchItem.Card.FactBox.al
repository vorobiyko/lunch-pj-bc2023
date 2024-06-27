page 60212 ItemsImagePart
{
    PageType = ListPart;
    SourceTable = LunchItem;
    PopulateAllFields = true;

    layout
    {  
        area(Content)
        {
            group("Item Picture")
            {   
                ShowCaption = false;
                field(Picture; Rec.Picture){
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Description){
                    ShowCaption = false;
                    StyleExpr = 'Strong';
                }
            }
            cuegroup("Description Item"){
                field(ItemPrice;Rec.Price){
                    ApplicationArea = Basic, Suite;
                    StyleExpr = 'Strong';
                    ShowCaption = false;
                }
                field(ItemWeight;Rec.Weight){
                    ApplicationArea = Basic, Suite;
                    StyleExpr = 'Strong';
                    ShowCaption = false;
                    Style=Favorable;
                }
            }
        }
        
    }
    

}

