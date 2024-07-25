page 60109 "Vendor API"
{
    PageType = Card;
    UsageCategory = None;

    var
        JSONDATA: JsonObject;
        LabelResponse: Label 'Error parsing JSON response';
        LabelStatusCode: Label 'Error: %1 %2';
        LabelReq: Label 'Failed to send request';
        LabelSuccessPost: Label 'Record %1 has been sent to Vendor';
        
    local procedure JSONParser(var JSON: JsonObject; MenuItemEntryNo: Integer): Boolean
    var
        DataRes: JsonToken;
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
        JSONDATA := JSON;
        JSONDATA.Get('data', DataRes);
        DataObj := DataRes.AsArray();
        repeat
            DataObj.Get(Iterator, AttributesDataRes);
            AttributesDataObj := AttributesDataRes.AsObject();
            AttributesDataObj.Get('attributes', AttributeRes);
            AttributeObj := AttributeRes.AsObject();
            AttributeObj.Get('Approved', ApprovedRes);
            AttributeObj.Get('MenuItemEntryNo', MenuItemEntryNoRes);
            StatusApprove := ApprovedRes.AsValue().AsBoolean();
            MenuItemEntryNoValue := MenuItemEntryNoRes.AsValue().AsText();
            if Format(MenuItemEntryNo) = MenuItemEntryNoValue then
                exit(StatusApprove);
            Iterator := Iterator + 1;
        until Iterator = DataObj.Count();
        exit(false);
    end;

    internal procedure GetVendorInfo(var VendorNo: Code[20]; PrevVendor: Code[20];MenuItemEntryNo: Integer): Boolean;
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        BearerToken: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
        Headers: HttpHeaders;
        EndPoint: Text;

    begin
        EndPoint := ChoiceVendorEndpoint(VendorNo);
        BearerToken := 'c91ddce1839bdb9f28c7893b3a6d50549174622bd69d4bde44324ef9602a71d220958b736392735efc9a1693f358ece54ed354e18bfde860a1c5d7b0cb44cb3f697519d66ddcca4cc2062cbbdd390ee80cbbc503a35f799f1f84dd2dc417ce6cd89c98487743158270e84df5d05b120e6d35b69949ce432844b4f1197bb45133';
        RequestMessage.Method := 'GET';
        RequestMessage.SetRequestUri('http://localhost:1337/api/' + EndPoint);
        RequestMessage.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + BearerToken);
        if PrevVendor = VendorNo then
            exit(JSONParser(JSONDATA, MenuItemEntryNo));
        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(ResponseText);
                if JsonResponse.ReadFrom(ResponseText) then begin
                    exit(JSONParser(JsonResponse, MenuItemEntryNo))
                end else begin
                    Error(LabelResponse);
                end;
            end else begin
                Error(LabelStatusCode, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
            end;
        end else begin
            Error(LabelReq);
        end;
    end;


    internal procedure PostVendorInfo(var VendorNo: Code[20];ItemNo: Code[20];Quantity: Decimal;OrderDate: Date;MenuItemEntryNo: Integer): Boolean
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        BearerToken: Text;
        ResponseText: Text;
        JsonResponse: JsonObject;
        Headers: HttpHeaders;
        JSONDataText: Text;
        ContentHeaders: HttpHeaders;
        CountJSONDataText: Text;
        EndPoint: Text;
    begin
        EndPoint := ChoiceVendorEndpoint(VendorNo);
        BearerToken := 'c91ddce1839bdb9f28c7893b3a6d50549174622bd69d4bde44324ef9602a71d220958b736392735efc9a1693f358ece54ed354e18bfde860a1c5d7b0cb44cb3f697519d66ddcca4cc2062cbbdd390ee80cbbc503a35f799f1f84dd2dc417ce6cd89c98487743158270e84df5d05b120e6d35b69949ce432844b4f1197bb45133';
        JSONDataText := '{"data":{"OrderDate":' + '"' + Format(OrderDate, 0, '<Year4>-<Month,2>-<Day,2>') + '"' + ',"ItemCode":' + '"' + Format(ItemNo) + '"' + ',"Quantity":' + Format(Quantity) + ',"Approved": false,"MenuItemEntryNo":' + '"' + Format(MenuItemEntryNo) + '"' + '}}';
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri('http://localhost:1337/api/' + EndPoint);
        RequestMessage.Content.WriteFrom(JSONDataText);
        RequestMessage.GetHeaders(Headers);
        Headers.add('Authorization', 'Bearer ' + BearerToken);
        RequestMessage.Content.GetHeaders(ContentHeaders);
        CountJSONDataText := Format(StrLen(JSONDataText));

        ContentHeaders.Add('Content-Length', CountJSONDataText);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(ResponseText);
                if JsonResponse.ReadFrom(ResponseText) then begin
                    Message(LabelSuccessPost,MenuItemEntryNo);
                    exit(true);
                end else begin
                    Error(LabelResponse);
                end;
            end else begin
                Error(LabelStatusCode, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
            end;
        end else begin
            Error(LabelReq);
        end;
    end;

    local procedure ChoiceVendorEndpoint(var VendorCode: Code[20]): Text
    var
        ErrLabel: Label 'Not found Vendor Code';
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
        PuzHat := '000008';
        MacDon := '000010';
        KFC := '000009';
        Mus := '000011';
        MamMan := '000012';
        PHEndpoint := 'ph-vens';
        MCEndpoint := 'mc-vens';
        KFCEndpoint := 'kfc-vens';
        MUSEndpoint := 'mus-vens';
        MMEndpoint := 'mm-vens';
        
        case VendorCode of
            PuzHat:
                exit(PHEndpoint);
            MacDon:
                exit(MCEndpoint);
            KFC:
                exit(KFCEndpoint);
            Mus:
                exit(MUSEndpoint);
            MamMan:
                exit(MMEndpoint);
        else
            Error(ErrLabel);
        end;
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
