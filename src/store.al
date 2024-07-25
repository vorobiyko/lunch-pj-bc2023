codeunit 60101 "IsolatedStorage"
{
    var PartList: List of [Text];
    [NonDebuggable]
    local procedure SetTokenAPI()
    var PartToken1: Text;
        PartToken2: Text;
        PartToken3: Text;
        PartToken4: Text;
        PartToken5: Text;
        NoSplitToken: Text;
        CountPart: Integer;
        Count: Integer;
        i: Integer;
    begin
        CountPart:= 5;
        NoSplitToken:= 'c91ddce1839bdb9f28c7893b3a6d50549174622bd69d4bde44324ef9602a71d220958b736392735efc9a1693f358ece54ed354e18bfde860a1c5d7b0cb44cb3f697519d66ddcca4cc2062cbbdd390ee80cbbc503a35f799f1f84dd2dc417ce6cd89c98487743158270e84df5d05b120e6d35b69949ce432844b4f1197bb45133';
        Count:= Round((StrLen(NoSplitToken)/CountPart), 1);
        for i:= 0 to CountPart do begin
            if (PartList.Count<CountPart) then begin
                PartList.Add(NoSplitToken.Substring(i*Count+1, Count));
            end else begin
                PartList.Add(NoSplitToken.Substring(i*Count+1));
            end;    
        end;
            
        IsolatedStorage.Set('Token'+PartList.Get(3), NoSplitToken, DataScope::Module);

    end;
    [NonDebuggable]
    internal procedure GetTokenAPI():Text
    var TokenTxt: Text;
        EncryptionManagement: Codeunit "Cryptography Management";
    begin
        SetTokenAPI();
        IsolatedStorage.Get('Token'+PartList.Get(3),DataScope::Module,TokenTxt);
        exit(TokenTxt);
    end;
}