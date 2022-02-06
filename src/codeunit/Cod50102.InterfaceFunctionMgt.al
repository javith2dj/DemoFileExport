codeunit 50102 "Interface Function Mgt."
{
    var
        GLNTxt: Label 'GLN', Locked = true;
        VATTxt: Label 'VAT', Locked = true;
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        TempVATProductPostingGroup: Record "VAT Product Posting Group" temporary;

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

    procedure GetSalesDocCurrencyCode(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesHeader."Currency Code" = '' then begin
            GLSetup.Get();
            GLSetup.TestField("LCY Code");
            CalcValue := Format(GLSetup."LCY Code");
        end;
        CalcValue := Format(SalesHeader."Currency Code");
    end;

    procedure GetStreetName(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := RespCenter.Address;
        CalcValue := CompInfo.Address;
    end;

    procedure GetAdditionalStreetName(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := RespCenter."Address 2";
        CalcValue := CompInfo."Address 2";
    end;

    procedure GetCityName(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := RespCenter.City;
        CalcValue := CompInfo.City;
    end;

    procedure GetPostalZone(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := RespCenter."Post Code";
        CalcValue := CompInfo."Post Code";
    end;

    procedure GetCountySubentity(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := RespCenter.County;
        CalcValue := CompInfo.County;
    end;

    procedure GetIdentificationCode(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        CompInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
    begin
        CompInfo.Get();
        if RespCenter.Get(SalesHeader."Responsibility Center") then
            CalcValue := GetCountryISOCode(RespCenter.County);
        CalcValue := GetCountryISOCode(CompInfo.County);
    end;

    procedure GetCompanyID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        PEPPOLMgt: Codeunit "Peppol Management";
        CompanyID: Text;
        CompanyIDSchemeID: Text;
        TaxSchemeID: Text;
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
                PEPPOLMgt.GetTaxCategories(SalesLine, TempVATProductPostingGroup);
            until SalesInvoiceLine.Next() = 0;
        PEPPOLMgt.GetAccountingSupplierPartyTaxSchemeBIS(
            TempVATAmtLine,
            CompanyID,
            CompanyIDSchemeID,
            TaxSchemeID);
        CalcValue := CompanyID;
    end;

    procedure GetTaxSchemeID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        PEPPOLMgt: Codeunit "Peppol Management";
        CompanyID: Text;
        CompanyIDSchemeID: Text;
        TaxSchemeID: Text;
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
                PEPPOLMgt.GetTaxCategories(SalesLine, TempVATProductPostingGroup);
            until SalesInvoiceLine.Next() = 0;
        PEPPOLMgt.GetAccountingSupplierPartyTaxSchemeBIS(
            TempVATAmtLine,
            CompanyID,
            CompanyIDSchemeID,
            TaxSchemeID);
        CalcValue := TaxSchemeID;
    end;

    procedure GetPartyLegalEntitySchemeID(var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        PartyLegalEntityRegName: Text;
        PartyLegalEntityCompanyID: Text;
        PartyLegalEntitySchemeID: Text;
        SupplierRegAddrCityName: Text;
        SupplierRegAddrCountryIdCode: Text;
        SupplRegAddrCountryIdListId: Text;
    begin
        PEPPOLMgt.GetAccountingSupplierPartyLegalEntityBIS(
                    PartyLegalEntityRegName,
                    PartyLegalEntityCompanyID,
                    PartyLegalEntitySchemeID,
                    SupplierRegAddrCityName,
                    SupplierRegAddrCountryIdCode,
                    SupplRegAddrCountryIdListId);
        CalcValue := PartyLegalEntitySchemeID;
    end;

    procedure GetCustomerSchemeIDBIS(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        Cust: Record Customer;
    begin
        Cust.Get(SalesHeader."Bill-to Customer No.");
        if (Cust.GLN <> '') and Cust."Use GLN in Electronic Document" then
            CalcValue := GetGLNSchemeIDByFormat(true)
        else
            CalcValue := GetVATScheme(SalesHeader."Bill-to Country/Region Code");
    end;

    procedure GetCustomerEndpointIDBIS(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        Cust: Record Customer;
    begin
        Cust.Get(SalesHeader."Bill-to Customer No.");
        if (Cust.GLN <> '') and Cust."Use GLN in Electronic Document" then
            CalcValue := Cust.GLN
        else
            CalcValue :=
              FormatVATRegistrationNo(
                SalesHeader.GetCustomerVATRegistrationNumber(), SalesHeader."Bill-to Country/Region Code", true, false);
    end;

    procedure GetCustPartySchemeCompID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        CustPartyTaxSchemeCompanyID: Text;
        CustPartyTaxSchemeCompIDSchID: Text;
        CustTaxSchemeID: Text;
    begin
        PEPPOLMgt.GetAccountingCustomerPartyTaxSchemeBIS(
            SalesHeader,
            CustPartyTaxSchemeCompanyID,
            CustPartyTaxSchemeCompIDSchID,
            CustTaxSchemeID);
        CalcValue := CustPartyTaxSchemeCompanyID;
    end;

    procedure GetCustPartyTaxSchemeCompIDSchID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        CustPartyTaxSchemeCompanyID: Text;
        CustPartyTaxSchemeCompIDSchID: Text;
        CustTaxSchemeID: Text;
    begin
        PEPPOLMgt.GetAccountingCustomerPartyTaxSchemeBIS(
            SalesHeader,
            CustPartyTaxSchemeCompanyID,
            CustPartyTaxSchemeCompIDSchID,
            CustTaxSchemeID);
        CalcValue := CustPartyTaxSchemeCompIDSchID;
    end;

    procedure Getcustcontactname(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    begin
        if SalesHeader."Bill-to Contact" <> '' then
            CalcValue := SalesHeader."Bill-to Contact"
        else
            CalcValue := SalesHeader."Bill-to Name";
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

    local procedure GetCountryISOCode(CountryRegionCode: Code[10]): Code[2]
    var
        CountryRegion: Record "Country/Region";
    begin
        CountryRegion.Get(CountryRegionCode);
        exit(CountryRegion."ISO Code");
    end;

}