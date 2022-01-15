codeunit 50100 "Export Invoice"
{
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    begin
        createxmlfile(Rec);
    end;

    var
        XMLChildNodes: Dictionary of [Text, XmlElement];
        XMLParentNodes: array[10] of XmlElement;
        HeaderRecordRef: RecordRef;

    local procedure createxmlfile(SalesInvHeader: Record "Sales Invoice Header")
    var
        ExportMapping: Record "Dyn. Export Buffer";
        ExportMapping2: Record "Dyn. Export Buffer";
        IntNamespace: Record "Interface Namespace/Prefix";
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
        XmlDocument.ReadFrom(GetInvoiceHeader(), XMLdocOut);
        XMLdocOut.GetRoot(RootNode);

        HeaderRecordRef.Open(Database::"Sales Invoice Header");
        HeaderRecordRef.GetTable(SalesInvHeader);

        ExportMapping.SetRange(Level, 1);
        if ExportMapping.FindSet() then
            repeat
                if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                if ExportMapping."Node Type" = ExportMapping."Node Type"::"Child Element" then begin
                    Clear(XmlCurrNode);
                    if ExportMapping."Source Type" = ExportMapping."Source Type"::Text then
                        CurrNodeValue := ExportMapping.Source;
                    if ExportMapping."Source Type" = ExportMapping."Source Type"::Field then begin
                        HeaderFieldRef := HeaderRecordRef.Field(ExportMapping."Field No.");
                        CurrNodeValue := HeaderFieldRef.Value;
                    end;
                    XmlCurrNode := XmlElement.Create(ExportMapping."Node Name", IntNamespace.Namespace, CurrNodeValue);
                    RootNode.Add(XmlCurrNode);
                end;
                if ExportMapping."Node Type" = ExportMapping."Node Type"::"Parent Element" then begin
                    CreateParentElements(ExportMapping, RootNode);
                end
            until ExportMapping.Next() = 0;
        TempBLOB.CreateOutStream(outs);
        XMLdocOut.WriteTo(outs);
        TempBLOB.CreateInStream(ins);
        filename := 'Export' + format(SalesInvHeader."No.") + '.xml';
        DownloadFromStream(ins, '', '', '', filename);
    end;

    procedure GetInvoiceHeader(): Text;
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

    procedure CreateParentElements(ExpMapping: Record "Dyn. Export Buffer"; var ParentNode: XmlElement)
    var
        ExportMapping: Record "Dyn. Export Buffer";
        TableLinkRec: Record "Interface Table Link";
        IntNamespace: Record "Interface Namespace/Prefix";
        TableLinkRecordRef: RecordRef;
        TableLinkFieldRef: array[10] of FieldRef;
        HeaderFieldRef: array[10] of FieldRef;
        CurrNodeFieldRef: FieldRef;
        FieldRefIncrement: Integer;
        XmlCurrNode: XmlElement;
        CurrNodeValue: Text;
    begin
        FieldRefIncrement := 1;
        if IntNamespace.Get(ExportMapping."Interface Code", ExpMapping.Prefix) then;
        XmlCurrNode := XmlElement.Create(ExpMapping."Node Name", IntNamespace.Namespace);
        If (ExpMapping."Table No." <> 0) then begin
            TableLinkRecordRef.Open(ExpMapping."Table No.");
            TableLinkRec.SetRange("Table No.", ExpMapping."Table No.");
            If TableLinkRec.FindSet() then
                repeat
                    HeaderFieldRef[FieldRefIncrement] := HeaderRecordRef.Field(TableLinkRec."Reference Field No.");
                    TableLinkFieldRef[FieldRefIncrement] := TableLinkRecordRef.Field(TableLinkRec."Field No.");
                    TableLinkFieldRef[FieldRefIncrement].SetRange(HeaderFieldRef[FieldRefIncrement].Value);
                    FieldRefIncrement += 1;
                until TableLinkRec.Next() = 0;
            if TableLinkRecordRef.FindSet() then
                repeat
                    ExportMapping.SetRange("Parent Node Name", ExpMapping."Node Name");
                    if ExportMapping.FindSet() then
                        repeat
                            if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                            if ExportMapping."Node Type" = ExportMapping."Node Type"::"Child Element" then begin
                                if ExportMapping."Source Type" = ExportMapping."Source Type"::Text then
                                    CurrNodeValue := ExportMapping.Source;
                                if ExportMapping."Source Type" = ExportMapping."Source Type"::Field then begin
                                    CurrNodeFieldRef := TableLinkRecordRef.Field(ExportMapping."Field No.");
                                    CurrNodeValue := CurrNodeFieldRef.Value;
                                end;
                                XmlCurrNode.Add(XmlElement.Create(ExportMapping."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                            end;
                            if ExportMapping."Node Type" = ExportMapping."Node Type"::"Parent Element" then begin

                                CreateParentElements(ExportMapping, XmlCurrNode);
                            end
                        until ExportMapping.Next() = 0;
                until TableLinkRecordRef.Next() = 0;
        end else begin
            ExportMapping.SetRange("Parent Node Name", ExpMapping."Node Name");
            if ExportMapping.FindSet() then
                repeat
                    if IntNamespace.Get(ExportMapping."Interface Code", ExportMapping.Prefix) then;
                    if ExportMapping."Node Type" = ExportMapping."Node Type"::"Child Element" then begin
                        if ExportMapping."Source Type" = ExportMapping."Source Type"::Text then
                            CurrNodeValue := ExportMapping.Source;
                        if ExportMapping."Source Type" = ExportMapping."Source Type"::Field then begin
                            CurrNodeFieldRef := HeaderRecordRef.Field(ExportMapping."Field No.");
                            CurrNodeValue := CurrNodeFieldRef.Value;
                        end;
                        XmlCurrNode.Add(XmlElement.Create(ExportMapping."Node Name", IntNamespace.NameSpace, CurrNodeValue));
                    end;
                    if ExportMapping."Node Type" = ExportMapping."Node Type"::"Parent Element" then begin

                        CreateParentElements(ExportMapping, XmlCurrNode);
                    end
                until ExportMapping.Next() = 0;
        end;
        ParentNode.Add(XmlCurrNode);
    end;
}