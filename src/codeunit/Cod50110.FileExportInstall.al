codeunit 50110 "File Export Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        IntFuncHandler: Codeunit "Interface Function Handler";
    begin
        IntFuncHandler.SetRegistrationMode(true);
        IntFuncHandler.Run();
    end;
}