codeunit 50101 "Interface Function Handler"
{
    trigger OnRun()
    begin
        if gRegistrationMode then begin
            RegisterFunctions();
        end else
            ExecuteCode(gFuncCode);
    end;

    var
        gRegistrationMode: Boolean;
        gCalculatedValue: Text;
        gFuncCode: Code[50];
        gLineRecRef: RecordRef;
        gSalesHdr: Record "Sales Header";
        gSalesLine: Record "Sales Line";

    local procedure RegisterFunctions()
    var
        IntFuncRec: Record "Interface Functions";
    begin
        IntFuncRec.DeleteAll();
        InsertInterfaceFunctionRec('SupplierEndPointIdBIS', 'Get Supplier Endpoint Id BIS');
        InsertInterfaceFunctionRec('SupplierSchemeIdBIS', 'Get Supplier Scheme Id BIS');
        InsertInterfaceFunctionRec('DocumentCurrencyCode', 'Get Document Currency Code');
        InsertInterfaceFunctionRec('StreetName', 'Get Street Name');
        InsertInterfaceFunctionRec('AdditionalStreetName', 'Get Additional Street Name');
        InsertInterfaceFunctionRec('CityName', 'Get City Name');
        InsertInterfaceFunctionRec('PostalZone', 'Get Postal Zone');
        InsertInterfaceFunctionRec('CountrySubentity', 'Get Country Sub Entity');
        InsertInterfaceFunctionRec('IdentificationCode', 'Get Identification Code');
        InsertInterfaceFunctionRec('CompanyID', 'Get Company ID');
        InsertInterfaceFunctionRec('TaxSchemeID', 'Get Tax Scheme ID');
        InsertInterfaceFunctionRec('PartyLegalEntitySchemeID', 'Get Party Legal Entity SchemeID');
        InsertInterfaceFunctionRec('CustomerEndPointIdBIS', 'Get Customer Endpoint Id BIS');
        InsertInterfaceFunctionRec('CustomerSchemeIdBIS', 'Get Customer Scheme Id BIS');
        InsertInterfaceFunctionRec('Custpartytaxschemecompanyid', 'Get Custpartytaxschemecompanyid');
        InsertInterfaceFunctionRec('CustPartyTaxSchemeCompIDSchID', 'Get CustPartyTaxSchemeCompIDSchID');
        InsertInterfaceFunctionRec('CustContactName', 'Get Customer Contact Name');
        InsertInterfaceFunctionRec('DeliveryID', 'Get Delivery ID');
        InsertInterfaceFunctionRec('DeliveryIDSchemeID', 'Get Delivery ID Scheme ID');
        InsertInterfaceFunctionRec('Payeefinancialaccountid', 'Get Payee financial accountid');
        InsertInterfaceFunctionRec('FinancialInstitutionBranchID', 'Get financial institution branch id');
        InsertInterfaceFunctionRec('PaymentTermsNote', 'Get Payment Terms Note');
        InsertInterfaceFunctionRec('TaxTotal', 'Get Tax Total');
        InsertInterfaceFunctionRec('TaxTotalCurrencyID', 'Get Tax Total Currency ID');
        InsertInterfaceFunctionRec('LineExtensionAmount', 'Get Line Extension Amount');
        InsertInterfaceFunctionRec('TaxExclusiveAmount', 'Get Tax Exclusive Amount');
        InsertInterfaceFunctionRec('TaxInclusiveAmount', 'Get Tax Inclusive amount');
        InsertInterfaceFunctionRec('AllowanceTotalAmount', 'Get Allowance Total Amount');
        InsertInterfaceFunctionRec('PayableRoundingAmount', 'Get Payable Rounding Amount');
        InsertInterfaceFunctionRec('PayableAmount', 'Get Payable Amount');
        InsertInterfaceFunctionRec('UnitCode', 'Get Unit Code');
        InsertInterfaceFunctionRec('Invoicelineextensionamount', 'Get Invoice Line Extension Amount');
        InsertInterfaceFunctionRec('SalesDocCurrencyCode', 'Get Currency Code');
        InsertInterfaceFunctionRec('Classifiedtaxcategoryid', 'Get Classified Tax Category Id');
        InsertInterfaceFunctionRec('Invoicelinetaxpercent', 'Get Invoice Line Tax Percent');
        InsertInterfaceFunctionRec('Classifiedtaxcategorytaxscheme', 'Get Classified Tax Category Tax Scheme');
        InsertInterfaceFunctionRec('Invoicelinepriceamount', 'Get Invoice Line Price Amount');
        InsertInterfaceFunctionRec('SubTotalTaxAmount', 'Get SubTotal Tax Amount');
        InsertInterfaceFunctionRec('TransactionCurrencyTaxAmount', 'Get Transaction Currency Tax Amount');
    end;

    local procedure InsertInterfaceFunctionRec(FuncCode: Code[50]; Desc: Text[250])
    var
        IntFuncRec: Record "Interface Functions";
    begin
        IntFuncRec.Init();
        IntFuncRec."Function Code" := FuncCode;
        IntFuncRec.Description := Desc;
        IntFuncRec.Insert();
    end;

    local procedure ExecuteCode(FunctionCode: Code[50])
    var
        IntFuncMgt: Codeunit "Interface Function Mgt.";
    begin
        case FunctionCode of
            'SupplierEndPointIdBIS':
                IntFuncMgt.SupplierEndPointIdBIS(gCalculatedValue);
            'SupplierSchemeIdBIS':
                IntFuncMgt.SupplierSchemeId(gCalculatedValue);
            'DocumentCurrencyCode':
                IntFuncMgt.GetSalesDocCurrencyCode(gSalesHdr, gCalculatedValue);
            'StreetName':
                IntFuncMgt.GetStreetName(gSalesHdr, gCalculatedValue);
            'AdditionalStreetName':
                IntFuncMgt.GetAdditionalStreetName(gSalesHdr, gCalculatedValue);
            'CityName':
                IntFuncMgt.GetCityName(gSalesHdr, gCalculatedValue);
            'PostalZone':
                IntFuncMgt.GetPostalZone(gSalesHdr, gCalculatedValue);
            'CountrySubentity':
                IntFuncMgt.GetCountySubentity(gSalesHdr, gCalculatedValue);
            'IdentificationCode':
                IntFuncMgt.GetCountySubentity(gSalesHdr, gCalculatedValue);
            'CompanyID':
                IntFuncMgt.GetCompanyID(gSalesHdr, gCalculatedValue);
            'TaxSchemeID':
                IntFuncMgt.GetTaxSchemeID(gSalesHdr, gCalculatedValue);
            'PartyLegalEntitySchemeID':
                IntFuncMgt.GetPartyLegalEntitySchemeID(gCalculatedValue);
            'CustomerEndpointIDBIS':
                IntFuncMgt.GetCustomerEndpointIDBIS(gSalesHdr, gCalculatedValue);
            'CustomerSchemeIDBIS':
                IntFuncMgt.GetCustomerSchemeIDBIS(gSalesHdr, gCalculatedValue);
            'Custpartytaxschemecompanyid':
                IntFuncMgt.GetCustPartySchemeCompID(gSalesHdr, gCalculatedValue);
            'CustPartyTaxSchemeCompIDSchID':
                IntFuncMgt.GetCustPartyTaxSchemeCompIDSchID(gSalesHdr, gCalculatedValue);
            'CustContactName':
                IntFuncMgt.Getcustcontactname(gSalesHdr, gCalculatedValue);
            'DeliveryID':
                IntFuncMgt.GetDeliveryID(gSalesHdr, gCalculatedValue);
            'DeliveryIDSchemeID':
                IntFuncMgt.GetDeliveryIDSchemeID(gSalesHdr, gCalculatedValue);
            'Payeefinancialaccountid':
                IntFuncMgt.GetPayeeFinancialAccountID(gCalculatedValue);
            'FinancialInstitutionBranchID':
                IntFuncMgt.GetFinancialInstitutionBranchID(gCalculatedValue);
            'PaymentTermsNote':
                IntFuncMgt.GetPaymenttermsnote(gSalesHdr, gCalculatedValue);
            'TaxTotal':
                IntFuncMgt.GetTaxTotal(gSalesHdr, gCalculatedValue);
            'TaxTotalCurrencyID':
                IntFuncMgt.GetTaxTotalCurrencyID(gSalesHdr, gCalculatedValue);
            'LineExtensionAmount':
                IntFuncMgt.GetLineExtensionAmount(gSalesHdr, gCalculatedValue);
            'TaxExclusiveAmount':
                IntFuncMgt.GetTaxExclusiveAmount(gSalesHdr, gCalculatedValue);
            'TaxInclusiveAmount':
                IntFuncMgt.GetTaxInclusiveAmount(gSalesHdr, gCalculatedValue);
            'AllowanceTotalAmount':
                IntFuncMgt.GetAllowanceTotalAmount(gSalesHdr, gCalculatedValue);
            'PayableRoundingAmount':
                IntFuncMgt.GetPayableRoundingAmount(gSalesHdr, gCalculatedValue);
            'PayableAmount':
                IntFuncMgt.GetPayableAmount(gSalesHdr, gCalculatedValue);
            'UnitCode':
                IntFuncMgt.GetunitCode(gSalesLine, gCalculatedValue);
            'Invoicelineextensionamount':
                IntFuncMgt.GetInvoiceLineExtensionAmount(gSalesLine, gCalculatedValue);
            'SalesDocCurrencyCode':
                IntFuncMgt.GetSalesDocCurrencyCode(gSalesHdr, gCalculatedValue);
            'Classifiedtaxcategoryid':
                IntFuncMgt.Getclassifiedtaxcategoryid(gSalesLine, gCalculatedValue);
            'Invoicelinetaxpercent':
                IntFuncMgt.GetInvoicelinetaxpercent(gSalesLine, gCalculatedValue);
            'Classifiedtaxcategorytaxscheme':
                IntFuncMgt.GetClassifiedtaxcategorytaxscheme(gSalesLine, gCalculatedValue);
            'Invoicelinepriceamount':
                IntFuncMgt.GetInvoiceLinePriceAmount(gSalesLine, gCalculatedValue);
            'SubTotalTaxAmount':
                IntFuncMgt.GetSubtotaltaxamount(gSalesLine, gCalculatedValue);
            'TransactionCurrencyTaxAmount':
                IntFuncMgt.GetTransactionCurrencyTaxAmount(gSalesLine, gCalculatedValue);
        end
    end;

    procedure SetRegistrationMode(pRegister: Boolean)
    begin
        gRegistrationMode := pRegister;
    end;

    procedure GetCalculatedValue(): Text
    begin
        exit(gCalculatedValue);
    end;

    procedure SetGlobals(FuncCode: Code[50]; Param1RecRef: RecordRef)
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
    begin
        gFuncCode := FuncCode;

        case Param1RecRef.Number of
            Database::"Sales Invoice Header":
                begin
                    Param1RecRef.SetTable(SalesInvHdr);
                    gSalesHdr.TransferFields(SalesInvHdr)
                end;
            Database::"Sales Invoice Line":
                begin
                    Param1RecRef.SetTable(SalesInvLine);
                    gSalesLine.TransferFields(SalesInvLine);
                end;
        end
    end;

}
