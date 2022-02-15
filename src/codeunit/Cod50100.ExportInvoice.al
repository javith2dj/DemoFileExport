codeunit 50100 "Export Invoice"
{
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    begin
        createxmlfile(Rec);
    end;

    var
        TableLinkIndexes: Dictionary of [Text, Integer];
        XMLParentNodes: array[10] of XmlElement;
        TableReferences: array[25] of RecordRef;
        HeaderRecordRef: RecordRef;
        InterfaceHdrRecord: Record "Interface Header";
        TableReferenceIndex: Integer;
        IncorrectFormatOrTypeErr: Label 'Incorrect format %1 or culture %2 specified for the node %3';

    local procedure createxmlfile(SalesInvHeader: Record "Sales Invoice Header")
    var
        ExportMapping: Record "Interface Line";
        ExportMapping2: Record "Interface Line";
        IntNamespace: Record "Interface Namespace/Prefix";
        CurrRecordRef: RecordRef;
        CurrFieldRef: FieldRef;
        ExpTextBuider: TextBuilder;
        HeaderFieldRef: FieldRef;
        RootNode: XmlElement;
        XmlCurrNode: XmlElement;
        XMLdocOut: XmlDocument;
        TempBLOB: codeunit "Temp Blob";
        ins: InStream;
        outs: OutStream;
        filename: Text;
        CurrNodeValue: Text;
        i: Integer;
    begin
        InterfaceHdrRecord.Get('PEPPOL3');
        XmlDocument.ReadFrom(GetInvoiceHeader(), XMLdocOut);
        XMLdocOut.GetRoot(RootNode);
        TableReferenceIndex := 1;
        HeaderRecordRef.Open(Database::"Sales Invoice Header");
        HeaderRecordRef.GetTable(SalesInvHeader);

        ExportMapping.SetRange("Interface Code", InterfaceHdrRecord."Interface Code");
        ExportMapping.SetRange(Level, 0);
        If ExportMapping.FindFirst() then begin
            TableReferences[TableReferenceIndex].Open(ExportMapping."Table No.");
            TableReferences[TableReferenceIndex].GetTable(SalesInvHeader);
            TableLinkIndexes.Add(ExportMapping."Node Name", TableReferenceIndex);
        end;

        ExportMapping.SetRange("Interface Code", InterfaceHdrRecord."Interface Code");
        ExportMapping.SetRange(Level, 1);
        if ExportMapping.FindSet() then
            repeat
                if ExportMapping.Parent then
                    CreateParentElements(ExportMapping, RootNode)
                else begin
                    CreateChildElement(ExportMapping, RootNode);
                end;
            until ExportMapping.Next() = 0;
        TempBLOB.CreateOutStream(outs);
        XMLdocOut.WriteTo(outs);
        TempBLOB.CreateInStream(ins);
        filename := 'Export' + format(SalesInvHeader."No.") + '.xml';
        DownloadFromStream(ins, '', '', '', filename);
    end;

    procedure GetInvoiceHeader(): Text;
    var
        PrefixBuilder: TextBuilder;
        InterfaceLine: Record "Interface Line";
        InterfaceNamespaces: Record "Interface Namespace/Prefix";
    begin
        PrefixBuilder.Append('<?xml version="1.0" encoding="UTF-8" ?>' +
        '<Invoice xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.0.xsd" ' +
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"');


        InterfaceNamespaces.SetRange("Interface Code", InterfaceHdrRecord."Interface Code");
        if InterfaceNamespaces.FindSet() then
            repeat
                PrefixBuilder.Append(' xmlns:' + InterfaceNamespaces.Prefix + '="' + InterfaceNamespaces.Namespace + '"')
            until InterfaceNamespaces.Next() = 0;

        PrefixBuilder.Append('/>');

        exit(PrefixBuilder.ToText());
    end;

    procedure CreateParentElements(pInterfaceLine: Record "Interface Line"; var ParentNode: XmlElement)
    var
        lInterfaceLine: Record "Interface Line";
        TableLinkRec: Record "Interface Link Table";
        IntNamespace: Record "Interface Namespace/Prefix";
        ParentTableRecordRef: RecordRef;
        LinkTableRecordRef: RecordRef;
        CurrRecordRef: RecordRef;
        LinkTableFieldRef: FieldRef;
        CurrFieldRef: FieldRef;
        ParentTableFieldRef: FieldRef;
        HeaderFieldRef: array[10] of FieldRef;
        CurrNodeFieldRef: FieldRef;
        FieldRefIncrement: Integer;
        XmlCurrNode: XmlElement;
        CurrNodeValue: Text;
    begin
        FieldRefIncrement := 1;
        If (pInterfaceLine."Node Type" = pInterfaceLine."Node Type"::"Table Element") then begin
            TableReferenceIndex += 1;
            TableReferences[TableReferenceIndex].Open(pInterfaceLine."Table No.");
            TableLinkRec.SetRange("Interface Code", pInterfaceLine."Interface Code");
            TableLinkRec.SetRange("Parent Reference Name", pInterfaceLine."Reference Name");
            if TableLinkRec.FindSet() then
                repeat
                    Clear(LinkTableRecordRef);
                    Clear(LinkTableFieldRef);
                    Clear(ParentTableFieldRef);
                    LinkTableRecordRef.Open(TableLinkRec."Link Table No.");
                    GetTableReferenceWithName(TableLinkRec."Link Reference Name", LinkTableRecordRef);
                    LinkTableFieldRef := LinkTableRecordRef.Field(TableLinkRec."Link Field No.");
                    ParentTableFieldRef := TableReferences[TableReferenceIndex].Field(TableLinkRec."Parent Field No.");
                    ParentTableFieldRef.SetRange(LinkTableFieldRef.Value);
                until TableLinkRec.Next() = 0;
            if TableLinkIndexes.ContainsKey(pInterfaceLine."Node Name") then
                TableLinkIndexes.Set(pInterfaceLine."Node Name", TableReferenceIndex)
            else
                TableLinkIndexes.Add(pInterfaceLine."Node Name", TableReferenceIndex);
            ParentTableRecordRef.Open(pInterfaceLine."Table No.");
            ParentTableRecordRef := TableReferences[TableReferenceIndex];
            if ParentTableRecordRef.FindSet() then
                repeat
                    if IntNamespace.Get(pInterfaceLine."Interface Code", pInterfaceLine.Prefix) then;
                    if pInterfaceLine."Xml Name" <> '' then
                        XmlCurrNode := XmlElement.Create(pInterfaceLine."Xml Name", IntNamespace.Namespace)
                    else
                        XmlCurrNode := XmlElement.Create(pInterfaceLine."Node Name", IntNamespace.Namespace);
                    AddAttributes(XmlCurrNode, pInterfaceLine);
                    lInterfaceLine.SetRange("Interface Code", pInterfaceLine."Interface Code");
                    lInterfaceLine.SetRange("Parent Node Name", pInterfaceLine."Node Name");
                    if lInterfaceLine.FindSet() then
                        repeat
                            if lInterfaceLine.Parent then
                                CreateParentElements(lInterfaceLine, XmlCurrNode)
                            else
                                CreateChildElement(lInterfaceLine, XmlCurrNode);
                        until lInterfaceLine.Next() = 0;
                    ParentNode.Add(XmlCurrNode);
                until ParentTableRecordRef.Next() = 0;
        end else begin
            if IntNamespace.Get(pInterfaceLine."Interface Code", pInterfaceLine.Prefix) then;
            if pInterfaceLine."Xml Name" <> '' then
                XmlCurrNode := XmlElement.Create(pInterfaceLine."Xml Name", IntNamespace.Namespace)
            else
                XmlCurrNode := XmlElement.Create(pInterfaceLine."Node Name", IntNamespace.Namespace);

            lInterfaceLine.SetRange("Interface Code", pInterfaceLine."Interface Code");
            lInterfaceLine.SetRange("Parent Node Name", pInterfaceLine."Node Name");
            if lInterfaceLine.FindSet() then
                repeat
                    if lInterfaceLine.Parent then begin
                        CreateParentElements(lInterfaceLine, XmlCurrNode)
                    end else
                        CreateChildElement(lInterfaceLine, XmlCurrNode);
                until lInterfaceLine.Next() = 0;
            if not XmlCurrNode.HasElements and pInterfaceLine."Not Blank" then
                exit;
            ParentNode.Add(XmlCurrNode);
        end;
    end;

    local procedure CreateChildElement(pInterfaceLine: Record "Interface Line"; var ParentNode: XmlElement)
    var
        IntNamespace: Record "Interface Namespace/Prefix";
        CurrNodeValue: Text;
        XmlCurrNode: XmlElement;
    begin
        if IntNamespace.Get(pInterfaceLine."Interface Code", pInterfaceLine.Prefix) then;
        case pInterfaceLine."Node Type" of
            pInterfaceLine."Node Type"::"Field Element":
                CurrNodeValue := GetFieldElementValue(pInterfaceLine);
            pInterfaceLine."Node Type"::"Text Element":
                CurrNodeValue := GetTextElementValue(pInterfaceLine);
            pInterfaceLine."Node Type"::"Function Element":
                CurrNodeValue := GetFunctionElementValue(pInterfaceLine);
        end;

        if pInterfaceLine."Not Blank" and (CurrNodeValue = '') then
            exit;

        if pInterfaceLine."Xml Name" <> '' then
            XmlCurrNode := XmlElement.Create(pInterfaceLine."Xml Name", IntNamespace.Namespace, CurrNodeValue)
        else
            XmlCurrNode := XmlElement.Create(pInterfaceLine."Node Name", IntNamespace.Namespace, CurrNodeValue);
        AddAttributes(XmlCurrNode, pInterfaceLine);
        ParentNode.Add(XmlCurrNode);
    end;

    local procedure GetTableReferenceWithName(ReferenceName: Text[30]; var CurrRecordRef: RecordRef)
    var
        ReferenceIndex: Integer;
    begin
        ReferenceIndex := TableLinkIndexes.Get(ReferenceName);
        CurrRecordRef := TableReferences[ReferenceIndex];
    end;

    local procedure GetFieldElementValue(InterfaceLine: Record "Interface Line"): Text
    var
        CurrRecordRef: RecordRef;
        CurrFieldRef: FieldRef;
    begin
        Clear(CurrRecordRef);
        Clear(CurrFieldRef);
        CurrRecordRef.Open(InterfaceLine."Table No.");
        GetTableReferenceWithName(InterfaceLine."Reference Name", CurrRecordRef);
        CurrFieldRef := CurrRecordRef.Field(InterfaceLine."Field No.");
        exit(SetValue(InterfaceLine, CurrFieldRef));
    end;

    local procedure GetAttributeFieldElementValue(InterfaceAttr: Record "Interface Line Attributes"): Text
    var
        CurrRecordRef: RecordRef;
        CurrFieldRef: FieldRef;
    begin
        Clear(CurrRecordRef);
        Clear(CurrFieldRef);
        CurrRecordRef.Open(InterfaceAttr."Table No.");
        GetTableReferenceWithName(InterfaceAttr."Reference Name", CurrRecordRef);
        CurrFieldRef := CurrRecordRef.Field(InterfaceAttr."Field No.");
        exit(CurrFieldRef.Value());
    end;

    local procedure GetTextElementValue(InterfaceLine: Record "Interface Line") TransformedValue: Text
    var
        TransformationRule: Record "Transformation Rule";
    begin
        TransformedValue := InterfaceLine.Source;
        if TransformationRule.Get(InterfaceLine."Transformation Rule") then
            TransformedValue := TransformationRule.TransformText(TransformedValue);
        exit(TransformedValue);
    end;

    local procedure GetFunctionElementValue(InterfaceLine: Record "Interface Line") TransformedValue: Text
    var
        TransformationRule: Record "Transformation Rule";
        SalesHeader: Record "Sales Header";
        CurrRecordRef: RecordRef;
        FuncCodeHandler: Codeunit "Interface Function Handler";
    begin
        if InterfaceLine.Source <> '' then begin
            if InterfaceLine."Reference Name" <> '' then begin
                GetTableReferenceWithName(InterfaceLine."Reference Name", CurrRecordRef);
                FuncCodeHandler.SetGlobals(InterfaceLine.Source, CurrRecordRef);
            end else
                FuncCodeHandler.SetGlobals(InterfaceLine.Source, HeaderRecordRef);
            FuncCodeHandler.Run();
            TransformedValue := FuncCodeHandler.GetCalculatedValue();
            if TransformationRule.Get(InterfaceLine."Transformation Rule") then
                TransformedValue := TransformationRule.TransformText(TransformedValue);
            exit(TransformedValue);
        end;
    end;

    local procedure SetValue(InterfaceLine: Record "Interface Line"; Var FieldRef: FieldRef) TransformedValue: Text
    var
        TransformationRule: Record "Transformation Rule";
        NegativeSignIdentifier: Text;
    begin
        TransformedValue := FieldRef.Value;

        case FieldRef.Type of
            FieldType::Date:
                SetDateDecimalField(TransformedValue, InterfaceLine, FieldRef);
            FieldType::Decimal:
                if InterfaceLine."Negative-Sign Identifier" = '' then begin
                    SetDateDecimalField(TransformedValue, InterfaceLine, FieldRef);
                    AdjustDecimalWithMultiplier(InterfaceLine.Multiplier, TransformedValue);
                end else begin
                    NegativeSignIdentifier := InterfaceLine."Negative-Sign Identifier";
                    TransformedValue := NegativeSignIdentifier + TransformedValue;
                end;
        end;

        if TransformationRule.Get(InterfaceLine."Transformation Rule") then
            TransformedValue := TransformationRule.TransformText(TransformedValue);
    end;

    local procedure SetDateDecimalField(var ValueText: Text; InterfaceLine: Record "Interface Line"; var FieldRef: FieldRef)
    var
        TypeHelper: Codeunit "Type Helper";
        Value: Variant;
    begin
        Value := FieldRef.Value;

        if InterfaceLine."Data Format" = '' then
            exit;

        if not TypeHelper.Evaluate(
             Value, ValueText, InterfaceLine."Data Format", InterfaceLine."Data Formatting Culture")
        then
            Error(StrSubStNo(IncorrectFormatOrTypeErr, InterfaceLine."Data Format", InterfaceLine."Data Formatting Culture", InterfaceLine."Node Name"));

        ValueText := Format(Value);
    end;

    local procedure AdjustDecimalWithMultiplier(Multiplier: Decimal; var ValueText: Text)
    var
        DecimalValue: Decimal;
    begin
        Evaluate(DecimalValue, ValueText);
        ValueText := Format(Multiplier * DecimalValue);
    end;

    local procedure AddAttributes(var CurrNode: XmlElement; InterfaceLine: Record "Interface Line")
    var
        IntLineAttributes: Record "Interface Line Attributes";
        FuncCodeHandler: Codeunit "Interface Function Handler";
        CurrRecordRef: RecordRef;
        AttributeValue: Text;
    begin
        IntLineAttributes.SetRange("Interface Code", InterfaceLine."Interface Code");
        IntLineAttributes.SetRange("Line No.", InterfaceLine."Line No.");
        If IntLineAttributes.FindSet() then
            repeat
                case IntLineAttributes."Attribute Type" of
                    IntLineAttributes."Attribute Type"::"Text Element":
                        begin
                            AttributeValue := IntLineAttributes."Attribute Value";
                        end;
                    IntLineAttributes."Attribute Type"::"Field Element":
                        begin
                            AttributeValue := GetAttributeFieldElementValue(IntLineAttributes);
                        end;
                    IntLineAttributes."Attribute Type"::"Function Element":
                        begin
                            if IntLineAttributes."Attribute Value" <> '' then begin
                                if IntLineAttributes."Reference Name" <> '' then begin
                                    GetTableReferenceWithName(IntLineAttributes."Reference Name", CurrRecordRef);
                                    FuncCodeHandler.SetGlobals(IntLineAttributes."Attribute Value", CurrRecordRef);
                                end else
                                    FuncCodeHandler.SetGlobals(IntLineAttributes."Attribute Value", HeaderRecordRef);
                                FuncCodeHandler.Run();
                                AttributeValue := FuncCodeHandler.GetCalculatedValue();
                            end;
                        end;
                end;

                if not ((AttributeValue = '') and IntLineAttributes."Not Blank") then
                    CurrNode.SetAttribute(IntLineAttributes."Attribute Key", AttributeValue);
            until IntLineAttributes.Next() = 0;
    end;

}