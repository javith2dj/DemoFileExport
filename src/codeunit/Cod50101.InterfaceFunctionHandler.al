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
        gParam1RecRef: RecordRef;
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

    local procedure ExecuteCode(FunctionCode: Code[20])
    var
        IntFuncMgt: Codeunit "Interface Function Mgt.";
        SalesHdr: Record "Sales Header";
    begin
        case FunctionCode of
            'SupplierEndPointIdBIS':
                IntFuncMgt.SupplierEndPointIdBIS(gCalculatedValue);
            'SupplierSchemeIdBIS':
                IntFuncMgt.SupplierSchemeId(gCalculatedValue);
            'DocumentCurrencyCode':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetSalesDocCurrencyCode(SalesHdr, gCalculatedValue);
                end;
            'StreetName':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetStreetName(SalesHdr, gCalculatedValue);
                end;
            'AdditionalStreetName':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetAdditionalStreetName(SalesHdr, gCalculatedValue);
                end;
            'CityName':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCityName(SalesHdr, gCalculatedValue);
                end;
            'PostalZone':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetPostalZone(SalesHdr, gCalculatedValue);
                end;
            'CountrySubentity':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCountySubentity(SalesHdr, gCalculatedValue);
                end;
            'IdentificationCode':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCountySubentity(SalesHdr, gCalculatedValue);
                end;
            'CompanyID':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCompanyID(SalesHdr, gCalculatedValue);
                end;
            'TaxSchemeID':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetTaxSchemeID(SalesHdr, gCalculatedValue);
                end;
            'PartyLegalEntitySchemeID':
                begin
                    IntFuncMgt.GetPartyLegalEntitySchemeID(gCalculatedValue);
                end;
            'CustomerEndpointIDBIS':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCustomerEndpointIDBIS(SalesHdr, gCalculatedValue);
                end;
            'CustomerSchemeIDBIS':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCustomerSchemeIDBIS(SalesHdr, gCalculatedValue);
                end;
            'Custpartytaxschemecompanyid':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCustPartySchemeCompID(SalesHdr, gCalculatedValue);
                end;
            'CustPartyTaxSchemeCompIDSchID':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.GetCustPartyTaxSchemeCompIDSchID(SalesHdr, gCalculatedValue);
                end;
            'CustContactName':
                begin
                    gParam1RecRef.SetTable(SalesHdr);
                    IntFuncMgt.Getcustcontactname(SalesHdr, gCalculatedValue);
                end;
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

    procedure SetGlobals(FuncCode: Code[20]; Param1RecRef: RecordRef)
    begin
        gFuncCode := FuncCode;
        gParam1RecRef := Param1RecRef;
    end;

}
