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
        gSalesHdr: Record "Sales Header";
        gSalesLine: Record "Sales Line";
        gRegistrationMode: Boolean;
        gCalculatedValue: Text;
        gLoopRecRef: RecordRef;
        gFuncCode: Code[50];
        gLineRecRef: RecordRef;


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
        InsertInterfaceFunctionRec('Taxtotaltaxcategoryid', 'Get Tax Total Tax Category Id');
        InsertInterfaceFunctionRec('TaxExemptionReason', 'Get Tax Exemption Reason');
        InsertInterfaceFunctionRec('Taxtotaltaxschemeid', 'Get Tax Total Tax Scheme Id');
        InsertInterfaceFunctionRec('VATAmtLineLoop', 'Get Sales Invoice Line VAT Amount Line Records');
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
                IntFuncMgt.GetIdentificationCode(gSalesHdr, gCalculatedValue);
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
            'TaxTotalTaxCategoryId':
                IntFuncMgt.GetTaxtotaltaxcategoryid(gSalesLine, gCalculatedValue);
            'TaxExemptionReason':
                IntFuncMgt.GetTaxExemptionReason(gSalesLine, gCalculatedValue);
            'VATAmtLineLoop':
                IntFuncMgt.GetVATAmtLineRec(gSalesHdr, gLoopRecRef);
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

    procedure GetLoopRecordRef(): RecordRef
    begin
        exit(gLoopRecRef);
    end;

    procedure GetLoopRecordRefTableNo(): Integer
    begin
        exit(gLoopRecRef.Number);
    end;

    procedure SetGlobals(FuncCode: Code[50]; Param1RecRef: RecordRef)
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        ServiceInvHeader: Record "Service Invoice Header";
        ServiceInvLine: Record "Service Invoice Line";
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
            Database::"Service Invoice Header":
                begin
                    Param1RecRef.SetTable(ServiceInvHeader);
                    TransferHeaderToSalesHeader(ServiceInvHeader, gSalesHdr);
                end;
            Database::"Service Invoice Line":
                begin
                    Param1RecRef.SetTable(ServiceInvLine);
                    TransferLineToSalesLine(ServiceInvLine, gSalesLine);
                    gSalesLine.Type := MapServiceLineTypeToSalesLineTypeEnum(ServiceInvLine.Type);
                end;
        end
    end;

    procedure TransferHeaderToSalesHeader(FromRecord: Variant; var ToSalesHeader: Record "Sales Header")
    var
        ToRecord: Variant;
    begin
        ToRecord := ToSalesHeader;
        RecRefTransferFields(FromRecord, ToRecord);
        ToSalesHeader := ToRecord;
    end;

    procedure TransferLineToSalesLine(FromRecord: Variant; var ToSalesLine: Record "Sales Line")
    var
        ToRecord: Variant;
    begin
        ToRecord := ToSalesLine;
        RecRefTransferFields(FromRecord, ToRecord);
        ToSalesLine := ToRecord;
    end;

    procedure RecRefTransferFields(FromRecord: Variant; var ToRecord: Variant)
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        i: Integer;
    begin
        FromRecRef.GetTable(FromRecord);
        ToRecRef.GetTable(ToRecord);
        for i := 1 to FromRecRef.FieldCount do begin
            FromFieldRef := FromRecRef.FieldIndex(i);
            if ToRecRef.FieldExist(FromFieldRef.Number) then begin
                ToFieldRef := ToRecRef.Field(FromFieldRef.Number);
                CopyField(FromFieldRef, ToFieldRef);
            end;
        end;
        ToRecRef.SetTable(ToRecord);
    end;

    local procedure CopyField(FromFieldRef: FieldRef; var ToFieldRef: FieldRef)
    begin
        if FromFieldRef.Class <> ToFieldRef.Class then
            exit;

        if FromFieldRef.Type <> ToFieldRef.Type then
            exit;

        if FromFieldRef.Length > ToFieldRef.Length then
            exit;

        ToFieldRef.Value := FromFieldRef.Value;
    end;

    procedure MapServiceLineTypeToSalesLineTypeEnum(ServiceLineType: Enum "Service Line Type"): Enum "Sales Line Type"
    var
        SalesLine: Record "Sales Line";
        ServiceInvoiceLine: Record "Service Invoice Line";
    begin
        case ServiceLineType of
            ServiceInvoiceLine.Type::" ":
                exit(SalesLine.Type::" ");
            ServiceInvoiceLine.Type::Item:
                exit(SalesLine.Type::Item);
            ServiceInvoiceLine.Type::Resource:
                exit(SalesLine.Type::Resource);
            else
                exit(SalesLine.Type::"G/L Account");
        end;
    end;

}
