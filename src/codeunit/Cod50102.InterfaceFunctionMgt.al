codeunit 50102 "Interface Function Mgt."
{
    var
        GLNTxt: Label 'GLN', Locked = true;
        VATTxt: Label 'VAT', Locked = true;

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
        end else
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
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        TempVATProductPostingGroup: Record "VAT Product Posting Group" temporary;
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
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        TempVATProductPostingGroup: Record "VAT Product Posting Group" temporary;
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

    procedure GetDeliveryID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        ActualDeliveryDate: Text;
        DeliveryID: Text;
        DeliveryIDSchemeID: Text;
    begin
        PEPPOLMgt.GetGLNDeliveryInfo(
            SalesHeader,
            ActualDeliveryDate,
            DeliveryID,
            DeliveryIDSchemeID);
        CalcValue := DeliveryID;
    end;

    procedure GetDeliveryIDSchemeID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        ActualDeliveryDate: Text;
        DeliveryID: Text;
        DeliveryIDSchemeID: Text;
    begin
        PEPPOLMgt.GetGLNDeliveryInfo(
            SalesHeader,
            ActualDeliveryDate,
            DeliveryID,
            DeliveryIDSchemeID);
        CalcValue := DeliveryIDSchemeID;
    end;

    procedure GetPayeeFinancialAccountID(var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        PayeeFinancialAccountID: Text;
        FinancialInstitutionBranchID: Text;
    begin
        PEPPOLMgt.GetPaymentMeansPayeeFinancialAccBIS(
            PayeeFinancialAccountID,
            FinancialInstitutionBranchID);
        CalcValue := PayeeFinancialAccountID;
    end;

    procedure GetFinancialInstitutionBranchID(var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        PayeeFinancialAccountID: Text;
        FinancialInstitutionBranchID: Text;
    begin
        PEPPOLMgt.GetPaymentMeansPayeeFinancialAccBIS(
            PayeeFinancialAccountID,
            FinancialInstitutionBranchID);
        CalcValue := FinancialInstitutionBranchID;
    end;

    procedure GetPaymenttermsnote(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        PEPPOLMgt.GetPaymentTermsInfo(
                    SalesHeader,
                    CalcValue);
    end;

    procedure GetTaxTotal(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
        TaxTotalCurrencyID: Text;
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        PEPPOLMgt.GetTaxTotalInfo(
          SalesHeader,
          TempVATAmtLine,
          CalcValue,
          TaxTotalCurrencyID);
    end;

    procedure GetTaxTotalCurrencyID(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
        TaxTotal: Text;
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        PEPPOLMgt.GetTaxTotalInfo(
          SalesHeader,
          TempVATAmtLine,
          TaxTotal,
          CalcValue);
    end;

    procedure GetLineExtensionAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(Round(TempVATAmtLine."VAT Base", 0.01) + Round(TempVATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
    end;

    procedure GetTaxExclusiveAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(Round(TempVATAmtLine."VAT Base", 0.01), 0, 9);
    end;

    procedure GetTaxInclusiveAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(Round(TempVATAmtLine."Amount Including VAT", 0.01, '>'), 0, 9);
    end;

    procedure GetAllowanceTotalAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(Round(TempVATAmtLine."Invoice Discount Amount", 0.01), 0, 9);
    end;

    procedure GetPayableRoundingAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(TempVATAmtLine."Amount Including VAT" - Round(TempVATAmtLine."Amount Including VAT", 0.01), 0, 9);
    end;

    procedure GetPayableAmount(SalesHeader: Record "Sales Header"; var CalcValue: Text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
        if SalesInvoiceLine.FindSet then
            repeat
                SalesLine.TransferFields(SalesInvoiceLine);
                PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            until SalesInvoiceLine.Next() = 0;
        TempVATAmtLine.Reset();
        TempVATAmtLine.CalcSums("Line Amount", "VAT Base", "Amount Including VAT", "Invoice Discount Amount");

        CalcValue := Format(Round(TempVATAmtLine."Amount Including VAT", 0.01), 0, 9);
    end;

    procedure GetunitCode(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        DummyVar: Text;
    begin
        PEPPOLMgt.GetLineUnitCodeInfo(SalesLine, CalcValue, DummyVar);
    end;

    procedure GetInvoiceLineExtensionAmount(SalesLine: Record "Sales Line"; var CalcValue: Text)
    begin
        CalcValue := Format(SalesLine."VAT Base Amount" + SalesLine."Inv. Discount Amount", 0, 9);
    end;

    procedure GetSalesDocCurrencyCode(SalesHeader: Record "Sales Header"): Code[10]
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if SalesHeader."Currency Code" = '' then begin
            GLSetup.Get();
            GLSetup.TestField("LCY Code");
            exit(GLSetup."LCY Code");
        end;
        exit(SalesHeader."Currency Code");
    end;

    procedure Getclassifiedtaxcategoryid(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        DummyVar: Text;
        InvoiceLineTaxPercent: Text;
        ClassifiedTaxCategorySchemeID: text;
    begin
        PEPPOLMgt.GetLineItemClassfiedTaxCategoryBIS(
            SalesLine,
            CalcValue,
            DummyVar,
            InvoiceLineTaxPercent,
            ClassifiedTaxCategorySchemeID);
    end;

    procedure GetInvoicelinetaxpercent(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        DummyVar: Text;
        Classifiedtaxcategoryid: Text;
        ClassifiedTaxCategorySchemeID: text;
    begin
        PEPPOLMgt.GetLineItemClassfiedTaxCategoryBIS(
            SalesLine,
            Classifiedtaxcategoryid,
            DummyVar,
            CalcValue,
            ClassifiedTaxCategorySchemeID);
    end;

    procedure GetClassifiedtaxcategorytaxscheme(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        PEPPOLMgt: Codeunit "PEPPOL Management";
        DummyVar: Text;
        InvoiceLineTaxPercent: Text;
        Classifiedtaxcategoryid: text;
    begin
        PEPPOLMgt.GetLineItemClassfiedTaxCategoryBIS(
            SalesLine,
            Classifiedtaxcategoryid,
            DummyVar,
            InvoiceLineTaxPercent,
            CalcValue);
    end;

    procedure GetInvoiceLinePriceAmount(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        unitCodeListID: Text;
        VATBaseIdx: Decimal;
        InvoiceLinePriceAmount: Text;
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then begin
            SalesInvHeader.Get(SalesLine."Document Type"::Invoice, SalesLine."Document No.");
            SalesHeader.TransferFields(SalesInvHeader);
        end else
            if SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then begin
                SalesCrHeader.Get(SalesLine."Document Type"::"Credit Memo", SalesLine."Document No.");
                SalesHeader.TransferFields(SalesCrHeader);
            end;

        if SalesHeader."Prices Including VAT" then begin
            VATBaseIdx := 1 + SalesLine."VAT %" / 100;
            InvoiceLinePriceAmount := Format(Round(SalesLine."Unit Price" / VATBaseIdx), 0, 9)
        end else
            InvoiceLinePriceAmount := Format(SalesLine."Unit Price", 0, 9);

        CalcValue := InvoiceLinePriceAmount;
    end;

    procedure GetSubtotaltaxamount(SalesLine: Record "Sales Line"; var CalcValue: Text)

    var
        SalesHEader: Record "Sales Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin

        SalesInvoiceLine.SetRange("Document No.", SalesLine."Document No.");
        SalesInvoiceLine.SetRange("Line No.", SalesLine."Line No.");
        if SalesInvoiceLine.Findfirst then begin
            SalesLine.TransferFields(SalesInvoiceLine);
            PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            CalcValue := Format(TempVATAmtLine."VAT Amount", 0, 9);
        end;
    end;

    procedure GetTransactionCurrencyTaxAmount(SalesLine: Record "Sales Line"; var CalcValue: Text)
    var
        SalesHEader: Record "Sales Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        TempVATAmtLine: Record "VAT Amount Line" temporary;
        GLSetup: Record "General Ledger Setup";
        PEPPOLMgt: Codeunit "PEPPOL Management";
    begin

        SalesInvoiceLine.SetRange("Document No.", SalesLine."Document No.");
        SalesInvoiceLine.SetRange("Line No.", SalesLine."Line No.");
        if SalesInvoiceLine.Findfirst then begin
            SalesLine.TransferFields(SalesInvoiceLine);
            PEPPOLMgt.GetTotals(SalesLine, TempVATAmtLine);
            GLSetup.Get();
            if GLSetup."LCY Code" <> GetSalesDocCurrencyCode(SalesHeader) then begin
                CalcValue :=
                  Format(
                    TempVATAmtLine.GetAmountLCY(
                      SalesHeader."Posting Date",
                      GetSalesDocCurrencyCode(SalesHeader),
                      SalesHeader."Currency Factor"), 0, 9);
                CalcValue := GLSetup."LCY Code";
            end;
        end;
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