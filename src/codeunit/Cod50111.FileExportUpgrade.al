codeunit 50111 "File Export Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        IntFuncHandler: Codeunit "Interface Function Handler";
    begin
        IntFuncHandler.SetRegistrationMode(true);
        IntFuncHandler.Run();
    end;
}