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

    procedure CreateParentElements(ExpMapping: Record "Interface Line"; var ParentNode: XmlElement)
    var
        ExportMapping: Record "Interface Line";
        TableLinkRec: Record "Interface Link Table";
        IntNamespace: Record "Interface Namespace/Prefix";
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
        If (ExpMapping."Node Type" = ExpMapping."Node Type"::"Table Element") then begin
            TableReferenceIndex += 1;
            TableReferences[TableReferenceIndex].Open(ExportMapping."Table No.");
            TableLinkRec.SetRange("Interface Code", ExpMapping."Interface Code");
            TableLinkRec.SetRange("Parent Reference Name", ExpMapping."Reference Name");
            if TableLinkRec.FindSet() then
                repeat
                    Clear(LinkTableRecordRef);
                    Clear(LinkTableFieldRef);
                    Clear(ParentTableFieldRef);
                    GetTableReferenceWithName(TableLinkRec."Link Reference Name", LinkTableRecordRef);
                    LinkTableFieldRef := LinkTableRecordRef.Field(TableLinkRec."Link Field No.");
                    ParentTableFieldRef := TableReferences[TableReferenceIndex].Field(TableLinkRec."Parent Field No.");
                    LinkTableFieldRef.SetRange(ParentTableFieldRef.Value);
                until TableLinkRec.Next() = 0;
            TableLinkIndexes.Add(ExportMapping."Node Name", TableReferenceIndex);
            if IntNamespace.Get(ExportMapping."Interface Code", ExpMapping.Prefix) then;
            XmlCurrNode := XmlElement.Create(ExpMapping."Node Name", IntNamespace.Namespace);
            if LinkTableRecordRef.FindSet() then
                repeat
                    ExportMapping.SetRange("Parent Node Name", ExpMapping."Node Name");
                    if ExportMapping.FindSet() then
                        repeat
                            if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                            if (ExportMapping."Node Type" = ExportMapping."Node Type"::"Field Element") and not ExportMapping.Parent then begin
                                Clear(XmlCurrNode);
                                Clear(CurrRecordRef);
                                Clear(CurrFieldRef);
                                GetTableReferenceWithName(ExportMapping."Reference Name", CurrRecordRef);
                                CurrFieldRef := CurrRecordRef.Field(ExportMapping."Field No.");
                                CurrNodeValue := CurrFieldRef.Value;
                                XmlCurrNode := XmlElement.Create(ExportMapping."Node Name", IntNamespace.Namespace, CurrNodeValue);
                            end;
                            if ExportMapping."Node Type" = ExportMapping."Node Type"::"Text Element" then begin
                                CurrNodeValue := ExportMapping.Source;
                                XmlCurrNode.Add(XmlElement.Create(ExportMapping."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                            end;
                            if ExportMapping.Parent then begin
                                CreateParentElements(ExportMapping, XmlCurrNode);
                            end
                        until ExportMapping.Next() = 0;
                until LinkTableRecordRef.Next() = 0;
        end else begin
            XmlCurrNode := XmlElement.Create(ExpMapping."Node Name", IntNamespace.Namespace);
            ExportMapping.SetRange("Parent Node Name", ExpMapping."Node Name");
            if ExportMapping.FindSet() then
                repeat
                    if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                    if (ExportMapping."Node Type" = ExportMapping."Node Type"::"Field Element") and ExportMapping.Parent then begin
                        CurrNodeFieldRef := HeaderRecordRef.Field(ExportMapping."Field No.");
                        CurrNodeValue := CurrNodeFieldRef.Value;
                        XmlCurrNode.Add(XmlElement.Create(ExportMapping."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                    end;
                    if ExportMapping."Node Type" = ExportMapping."Node Type"::"Text Element" then begin
                        CurrNodeValue := ExportMapping.Source;
                        XmlCurrNode.Add(XmlElement.Create(ExportMapping."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                    end;
                    if ExportMapping.Parent then
                        CreateParentElements(ExportMapping, XmlCurrNode);

                until ExportMapping.Next() = 0;
        end;
        ParentNode.Add(XmlCurrNode);
    end;

    procedure GetTableReferenceWithName(ReferenceName: Text[30]; var CurrRecordRef: RecordRef)
    var
        ReferenceIndex: Integer;
    begin
        ReferenceIndex := TableLinkIndexes.Get(ReferenceName);
        CurrRecordRef := TableReferences[ReferenceIndex];
    end;
}