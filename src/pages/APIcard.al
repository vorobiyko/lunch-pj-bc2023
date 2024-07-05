page 60109 VendorApi
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'Vendor Info Card';
    
    layout
    {
        area(Content)
        {
            group(GeneralFastTab)
            {
                Caption = 'General';
                field(Id;Id)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                }
                field(OrderDate;OrderDate)
                {
                    ApplicationArea = All;
                    Caption = 'OrderDate';
                }
                field(Item;Item)
                {
                    ApplicationArea = All;
                    Caption = 'Item';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                }
                
            }
            
        }
    }
    // actions
    // {
    //     area(Processing)
    //     {
    //         action(GetData)
    //         {
    //             ApplicationArea = All;
    //             Image = GetOrder;
    //             trigger OnAction()
    //             begin
    //                 GetVendorInfo();               
    //             end;
    //         }
    //         action(PostVendor)
    //         {
    //             Image = Post;
    //             trigger OnAction()
    //             begin
    //                 PostVendorInfo();
    //             end;
    //         }
    //     }
    // }
    
    
    
    var
        Id: Integer;
        OrderDate: Date;
        Item: Code[20];
        Quantity: Decimal;
        Approved: Boolean;
        MenuItemEntryNo: Text;
        
        JSONDATA: JsonObject;

    procedure JSONParser(var JSON: JsonObject; MenuItemEntryNo: Integer):Boolean
    var DataRes: JsonToken;
        DataObj: JsonArray;
        AttributesDataRes: JsonToken;
        AttributesDataObj: JsonObject;
        AttributeRes: JsonToken;
        AttributeObj: JsonObject;
        ApprovedRes: JsonToken;
        MenuItemEntryNoRes: JsonToken;
        StatusApprove: Boolean;
        MenuItemEntryNoValue: Text; 
        Iterator: Integer;
    begin
        JSONDATA:= JSON;
        JSONDATA.Get('data', DataRes);
        DataObj:= DataRes.AsArray();
        repeat
            DataObj.Get(Iterator, AttributesDataRes);
            AttributesDataObj:= AttributesDataRes.AsObject();
            AttributesDataObj.Get('attributes', AttributeRes);
            AttributeObj:= AttributeRes.AsObject();
            AttributeObj.Get('Approved', ApprovedRes);
            AttributeObj.Get('MenuItemEntryNo', MenuItemEntryNoRes);
            StatusApprove:= ApprovedRes.AsValue().AsBoolean();
            MenuItemEntryNoValue:= MenuItemEntryNoRes.AsValue().AsText();
            if Format(MenuItemEntryNo) = MenuItemEntryNoValue then begin
                exit(StatusApprove);
            end;
            Iterator:=Iterator+1;
        until Iterator=DataObj.Count();
        exit(false);
    end;
    // AttributeObj:= AttributeRes.AsObject();
                    // AttributeObj.Get('ITMCode', ItemRes);
                    // AttributeObj.Get('OrderDate',OrderDateRes);
                    // AttributeObj.Get('Quantity', QuantityRes);
                    // Id:= IdRes.AsValue().AsInteger();
                    // Item:= ItemRes.AsValue().AsCode();
    procedure GetVendorInfo(var VendorNo: Code[20]; PrevVendor: Code[20]; MenuItemEntryNo: Integer):Boolean;
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        BearerToken: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
        Headers: HttpHeaders;
        TokenH: Text;
        SecretHeader: Text;
        AttributeRes: JsonToken;
        IdRes: JsonToken;
        ItemRes: JsonToken;
        OrderDateRes: JsonToken;
        QuantityRes: JsonToken;
        AttributeObj: JsonObject;
        IdObj: JsonObject;
        DataObj: JsonObject;
        EndPoint: Text;
        IsApprove: Boolean;

    begin
        EndPoint:=ChoiceVendorEndpoint(VendorNo);
    // Ваш токен доступу
        BearerToken := 'c91ddce1839bdb9f28c7893b3a6d50549174622bd69d4bde44324ef9602a71d220958b736392735efc9a1693f358ece54ed354e18bfde860a1c5d7b0cb44cb3f697519d66ddcca4cc2062cbbdd390ee80cbbc503a35f799f1f84dd2dc417ce6cd89c98487743158270e84df5d05b120e6d35b69949ce432844b4f1197bb45133';
        // Створення повідомлення запиту
        RequestMessage.Method:= 'GET';
        RequestMessage.SetRequestUri('http://localhost:1337/api/'+EndPoint);
        // Додавання заголовків
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization','Bearer '+BearerToken);
        // exit(false);
        if PrevVendor=VendorNo then begin
            exit(JSONParser(JSONDATA,MenuItemEntryNo));
        end;
    // Відправка запиту
        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(ResponseText);
                if JsonResponse.ReadFrom(ResponseText) then begin
                    // Обробка відповіді JSON
                    exit(JSONParser(JsonResponse, MenuItemEntryNo))
                    // DataObj:= DataRes.AsObject();
                    // DataObj.Get('attributes', AttributeRes);
                    // DataObj.Get('id', IdRes);
                    // // IdObj:= IdRes.AsObject();
                    // AttributeObj:= AttributeRes.AsObject();
                    // AttributeObj.Get('ITMCode', ItemRes);
                    // AttributeObj.Get('OrderDate',OrderDateRes);
                    // AttributeObj.Get('Quantity', QuantityRes);
                    // Id:= IdRes.AsValue().AsInteger();
                    // Item:= ItemRes.AsValue().AsCode();
                    // OrderDate:= OrderDateRes.AsValue().AsDate();
                    // Quantity:= QuantityRes.AsValue().AsDecimal();
                    // Message('Response: %1', Item);
                end else begin
                    Message('Error parsing JSON response');
                    exit(false)
                end;
            end else begin
                Message('Error: %1 %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
                exit(false);
            end;
        end else begin
            Message('Failed to send request');
            exit(false);
        end;
end;


    procedure PostVendorInfo(var VendorNo: Code[20]; ItemNo: Code[20]; Quantity: Decimal; OrderDate: Date; MenuItemEntryNo: Integer): Boolean
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        BearerToken: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
        Headers: HttpHeaders;
        AttributeRes: JsonToken;
        IdRes: JsonToken;
        ItemRes: JsonToken;
        OrderDateRes: JsonToken;
        QuantityRes: JsonToken;
        ApprovedRes: JsonToken;
        MenuItemEntryNoRes: JsonToken;
        AttributeObj: JsonObject;
        IdObj: JsonObject;
        DataObj: JsonObject;
        JSONDataText: Text;
        ContentHeaders: HttpHeaders;
        CountJSONDataText: Text;
        EndPoint: Text;
        
    begin
        EndPoint:=ChoiceVendorEndpoint(VendorNo);
        // Ваш токен доступу
        
        BearerToken := 'c91ddce1839bdb9f28c7893b3a6d50549174622bd69d4bde44324ef9602a71d220958b736392735efc9a1693f358ece54ed354e18bfde860a1c5d7b0cb44cb3f697519d66ddcca4cc2062cbbdd390ee80cbbc503a35f799f1f84dd2dc417ce6cd89c98487743158270e84df5d05b120e6d35b69949ce432844b4f1197bb45133';
        JSONDataText:= '{"data":{"OrderDate":'+'"'+Format(OrderDate, 0, '<Year4>-<Month,2>-<Day,2>')+'"'+',"ItemCode":'+'"'+Format(ItemNo)+'"'+',"Quantity":'+Format(Quantity)+',"Approved": false,"MenuItemEntryNo":'+'"'+Format(MenuItemEntryNo)+'"'+'}}';
        // Створення повідомлення запиту
        RequestMessage.Method:= 'POST';
        RequestMessage.SetRequestUri('http://localhost:1337/api/'+EndPoint);
        RequestMessage.Content.WriteFrom(JSONDataText);
        // Додавання заголовків
        RequestMessage.GetHeaders(Headers);
        Headers.add('Authorization','Bearer '+BearerToken);
        RequestMessage.Content.GetHeaders(ContentHeaders);
        CountJSONDataText:= Format(StrLen(JSONDataText));
        ContentHeaders.Add('Content-Length', CountJSONDataText);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
    
        
    // Відправка запиту
        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(ResponseText);
                if JsonResponse.ReadFrom(ResponseText) then begin
                    // Обробка відповіді JSON
                    // JsonResponse.Get('data', DataRes);
                    // DataObj:= DataRes.AsObject();
                    // DataObj.Get('attributes', AttributeRes);
                    // DataObj.Get('id', IdRes);
                    // AttributeObj:= AttributeRes.AsObject();
                    // AttributeObj.Get('ITMCode', ItemRes);
                    // AttributeObj.Get('OrderDate',OrderDateRes);
                    // AttributeObj.Get('Quantity', QuantityRes);
                    // Id:= IdRes.AsValue().AsInteger();
                    // Item:= ItemRes.AsValue().AsCode();
                    // OrderDate:= OrderDateRes.AsValue().AsDate();
                    // Quantity:= QuantityRes.AsValue().AsDecimal();
                    Message('Record has been sent to Vendor');
                    exit(true);
                end else begin
                    Message('Error parsing JSON response');
                    exit(false);
                end;
            end else begin
                Message('Error: %1 %2 %3' , ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
                exit(false);
            end;
        end else begin
            Message('Failed to send request');
            exit(false);
        end;
    end;
    procedure ChoiceVendorEndpoint(var VendorCode: Code[20]): Text
    var
        PuzHat: Code[20];
        MacDon: Code[20];
        KFC: Code[20];
        Mus: Code[20];
        MamMan: Code[20];
        PHEndpoint: Text;
        MCEndpoint: Text;
        KFCEndpoint: Text;
        MUSEndpoint: Text;
        MMEndpoint: Text;
    begin
        PuzHat:= '000008';
        MacDon:= '000010';
        KFC:= '000009';
        Mus:= '000011';
        MamMan:= '000012';
        PHEndpoint:= 'ph-vens';
        MCEndpoint:='mc-vens';
        KFCEndpoint:='kfc-vens';
        MUSEndpoint:='mus-vens';
        MMEndpoint:= 'mm-vens';
        if VendorCode=PuzHat then
            exit(PHEndpoint);
        if VendorCode=MacDon then
            exit(MCEndpoint);
        if VendorCode=KFC then
            exit(KFCEndpoint);
        if VendorCode=Mus then
            exit(MUSEndpoint);
        if VendorCode=MamMan then
            exit(MMEndpoint);
    end;
}
// {
//     "data":{
//             "OrderDate": "2045-07-02",
//             "ItemCode": "ITM005",
//             "Quantity": 3,
//             "Approved": false,
//             "MenuItemEntryNo": '753'
//         }
// }
