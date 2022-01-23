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
        InterfaceHdrRecord.Get('DEMO');
        XmlDocument.ReadFrom(GetInvoiceHeader(), XMLdocOut);
        XMLdocOut.GetRoot(RootNode);
        TableReferenceIndex := 1;
        HeaderRecordRef.Open(Database::"Sales Invoice Header");
        HeaderRecordRef.GetTable(SalesInvHeader);
        ExportMapping.SetRange(Level, 0);
        If ExportMapping.FindFirst() then begin
            TableReferences[TableReferenceIndex].Open(ExportMapping."Table No.");
            TableReferences[TableReferenceIndex].GetTable(SalesInvHeader);
            TableLinkIndexes.Add(ExportMapping."Node Name", TableReferenceIndex);
        end;

        ExportMapping.SetRange(Level, 1);
        if ExportMapping.FindSet() then
            repeat
                if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                if (ExportMapping."Node Type" = ExportMapping."Node Type"::"Text Element") and not (ExportMapping.Parent) then begin
                    Clear(XmlCurrNode);
                    CurrNodeValue := ExportMapping.Source;
                    XmlCurrNode := XmlElement.Create(ExportMapping."Node Name", IntNamespace.Namespace, CurrNodeValue);
                    RootNode.Add(XmlCurrNode);
                end;
                if ExportMapping."Node Type" = ExportMapping."Node Type"::"Field Element" then begin
                    Clear(XmlCurrNode);
                    Clear(CurrRecordRef);
                    Clear(CurrFieldRef);
                    GetTableReferenceWithName(ExportMapping."Reference Name", CurrRecordRef);
                    CurrFieldRef := CurrRecordRef.Field(ExportMapping."Field No.");
                    CurrNodeValue := CurrFieldRef.Value;
                    XmlCurrNode := XmlElement.Create(ExportMapping."Node Name", IntNamespace.Namespace, CurrNodeValue);
                    RootNode.Add(XmlCurrNode);
                end;
                if ExportMapping.Parent then begin
                    CreateParentElements(ExportMapping, RootNode);
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
    begin
        exit('<?xml version="1.0" encoding="UTF-8" ?>' +
        '<Invoice xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.0.xsd" ' +
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" ' +
        'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' +
        'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' +
        'xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" ' +
        'xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" ' +
        'xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"/>');
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
                    XmlCurrNode := XmlElement.Create(pInterfaceLine."Node Name", IntNamespace.Namespace);
                    lInterfaceLine.SetRange("Parent Node Name", pInterfaceLine."Node Name");
                    if lInterfaceLine.FindSet() then
                        repeat
                            if IntNamespace.Get(lInterfaceLine."Interface Code", lInterfaceLine.Prefix) then;
                            if (lInterfaceLine."Node Type" = lInterfaceLine."Node Type"::"Field Element") then begin
                                Clear(CurrRecordRef);
                                Clear(CurrFieldRef);
                                CurrRecordRef.Open(lInterfaceLine."Table No.");
                                GetTableReferenceWithName(lInterfaceLine."Reference Name", CurrRecordRef);
                                CurrFieldRef := CurrRecordRef.Field(lInterfaceLine."Field No.");
                                CurrNodeValue := CurrFieldRef.Value;
                                XmlCurrNode.Add(XmlElement.Create(lInterfaceLine."Node Name", IntNamespace.Namespace, CurrNodeValue));
                            end;
                            if (lInterfaceLine."Node Type" = lInterfaceLine."Node Type"::"Text Element") and not lInterfaceLine.Parent then begin
                                CurrNodeValue := lInterfaceLine.Source;
                                XmlCurrNode.Add(XmlElement.Create(lInterfaceLine."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                            end;
                            if lInterfaceLine.Parent then
                                CreateParentElements(lInterfaceLine, XmlCurrNode);

                        until lInterfaceLine.Next() = 0;
                    ParentNode.Add(XmlCurrNode);
                until ParentTableRecordRef.Next() = 0;
        end else begin
            if IntNamespace.Get(pInterfaceLine."Interface Code", pInterfaceLine.Prefix) then;
            XmlCurrNode := XmlElement.Create(pInterfaceLine."Node Name", IntNamespace.Namespace);
            lInterfaceLine.SetRange("Parent Node Name", pInterfaceLine."Node Name");
            if lInterfaceLine.FindSet() then
                repeat
                    if IntNamespace.Get(lInterfaceLine."Interface Code", lInterfaceLine.Prefix) then;
                    if (lInterfaceLine."Node Type" = lInterfaceLine."Node Type"::"Field Element") and lInterfaceLine.Parent then begin
                        Clear(CurrRecordRef);
                        Clear(CurrFieldRef);
                        CurrRecordRef.Open(lInterfaceLine."Table No.");
                        GetTableReferenceWithName(lInterfaceLine."Reference Name", CurrRecordRef);
                        CurrFieldRef := CurrRecordRef.Field(lInterfaceLine."Field No.");
                        CurrNodeValue := CurrFieldRef.Value;
                        XmlCurrNode.Add(XmlElement.Create(lInterfaceLine."Node Name", IntNamespace.Namespace, CurrNodeValue));
                    end;
                    if (lInterfaceLine."Node Type" = lInterfaceLine."Node Type"::"Text Element") and not lInterfaceLine.Parent then begin
                        CurrNodeValue := lInterfaceLine.Source;
                        XmlCurrNode.Add(XmlElement.Create(lInterfaceLine."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                    end;
                    if lInterfaceLine.Parent then
                        CreateParentElements(lInterfaceLine, XmlCurrNode);

                until lInterfaceLine.Next() = 0;
            ParentNode.Add(XmlCurrNode);
        end;
    end;

    procedure GetTableReferenceWithName(ReferenceName: Text[30]; var CurrRecordRef: RecordRef)
    var
        ReferenceIndex: Integer;
    begin
        ReferenceIndex := TableLinkIndexes.Get(ReferenceName);
        CurrRecordRef := TableReferences[ReferenceIndex];
    end;
}