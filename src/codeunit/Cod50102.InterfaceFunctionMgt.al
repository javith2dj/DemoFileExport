codeunit 50102 "Interface Function Mgt."
{
    var
        GLNTxt: Label 'GLN', Locked = true;

    procedure SupplierEndPointIdBIS(var CalcValue: Text)
    var
        CompanyInfo: Record "Company Information";
        IsBISBilling: Boolean;
    begin
        IsBISBilling := true;
        CompanyInfo.Get();
        if (CompanyInfo.GLN <> '') and CompanyInfo."Use GLN in Electronic Document" then begin
            CalcValue := CompanyInfo.GLN;
        end else
            CalcValue :=
              FormatVATRegistrationNo(CompanyInfo.GetVATRegistrationNumber(), CompanyInfo."Country/Region Code", IsBISBilling, false);

    end;

    procedure SupplierSchemeId(var CalcValue: Text)
    var
        CompanyInfo: Record "Company Information";
        IsBISBilling: Boolean;
    begin
        IsBISBilling := true;
        CompanyInfo.Get();
        if (CompanyInfo.GLN <> '') and CompanyInfo."Use GLN in Electronic Document" then begin
            CalcValue := GetGLNSchemeIDByFormat(IsBISBilling);
        end else
            CalcValue :=
              GetVATScheme(CompanyInfo."Country/Region Code");
    end;

    local procedure FormatVATRegistrationNo(VATRegistrationNo: Text; CountryCode: Code[10]; IsBISBilling: Boolean; IsPartyTaxScheme: Boolean): Text
    var
        CountryRegion: Record "Country/Region";
    begin
        if VATRegistrationNo = '' then
            exit;
        if IsBISBilling then begin
            VATRegistrationNo := DelChr(VATRegistrationNo);

            if IsPartyTaxScheme then
                if CountryRegion.Get(CountryCode) and (CountryRegion."ISO Code" <> '') then
                    if StrPos(VATRegistrationNo, CountryRegion."ISO Code") <> 1 then
                        VATRegistrationNo := CountryRegion."ISO Code" + VATRegistrationNo;
        end;

        exit(VATRegistrationNo);
    end;

    local procedure GetGLNSchemeIDByFormat(IsBISBillling: Boolean): Text
    begin
        if IsBISBillling then
            exit(GetGLNSchemeID());
        exit(GLNTxt);
    end;

    local procedure GetGLNSchemeID(): Text
    begin
        exit('0088');
    end;

    local procedure GetVATSchemeByFormat(CountryRegionCode: Code[10]; IsBISBilling: Boolean): Text
    begin
        if IsBISBilling then
            exit('');
        exit(GetVATScheme(CountryRegionCode));
    end;

    local procedure GetVATScheme(CountryRegionCode: Code[10]): Text
    var
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "Company Information";
    begin
        if CountryRegionCode = '' then begin
            CompanyInfo.Get();
            CompanyInfo.TestField("Country/Region Code");
            CountryRegion.Get(CompanyInfo."Country/Region Code");
        end else
            CountryRegion.Get(CountryRegionCode);
        exit(CountryRegion."VAT Scheme");
    end;
}