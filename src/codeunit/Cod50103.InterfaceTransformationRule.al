codeunit 50103 "Interface Transformation Rule"
{
    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnTransformation', '', false, false)]
    local procedure OnTransformation(TransformationCode: Code[20]; InputText: Text; var OutputText: Text);
    begin
        case TransformationCode of
            'XMLFORMAT':
                XMLFormat(InputText, OutputText);
            'XMLDATEFORMAT':
                XMLDateFormat(InputText, OutputText);
            'XMLDECIMALFORMAT':
                XMLDecimalFormat(InputText, OutputText);
        end
    end;

    local procedure XMLFormat(InputText: Text; var OutputText: Text)
    begin
        OutputText := Format(InputText, 0, 9);
    end;

    local procedure XMLDateFormat(InputText: Text; var OutputText: Text)
    var
        CurrDate: Date;
    begin
        Evaluate(CurrDate, InputText);
        OutputText := Format(CurrDate, 0, 9);
    end;

    local procedure XMLDecimalFormat(InputText: Text; var OutputText: Text)
    var
        CurrDecimal: Decimal;
    begin
        Evaluate(CurrDecimal, InputText);
        OutputText := Format(CurrDecimal, 0, 9);
    end;

}