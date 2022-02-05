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

    local procedure RegisterFunctions()
    var
        IntFuncRec: Record "Interface Functions";
    begin
        IntFuncRec.DeleteAll();
        InsertInterfaceFunctionRec('SupplierEndPointIdBIS', 'Get Supplier Endpoint Id BIS');
        InsertInterfaceFunctionRec('SupplierSchemeIdBIS', 'Get Supplier Scheme Id BIS');
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
    begin
        case FunctionCode of
            'SupplierEndPointIdBIS':
                IntFuncMgt.SupplierEndPointIdBIS(gCalculatedValue);
            'SupplierSchemeIdBIS':
                IntFuncMgt.SupplierSchemeId(gCalculatedValue);
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

    procedure SetGlobals(FuncCode: Code[20])
    begin
        gFuncCode := FuncCode;
    end;

}