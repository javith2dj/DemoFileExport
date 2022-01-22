table 50104 "Interface Link Table"
{
    fields
    {
        field(1; "Interface Code"; Code[20])
        {

        }
        field(2; "Parent Table No."; Integer)
        {

        }

        field(3; "Parent Table Name"; Text[30])
        {

        }
        field(4; "Link Table No."; Integer)
        {

        }
        field(5; "Link Table Name"; Text[30])
        {
            trigger OnLookup()
            var
                AllObj: Record AllObjWithCaption;
                InterfaceTableLink: Record "Interface Link Table";
                TableNoList: List of [Text];
                TableNoFilterText: Text;
                TableNo: Text;
            begin
                InterfaceTableLink.SetRange("Interface Code", "Interface Code");
                If InterfaceTableLink.Findset then
                    repeat
                        If not TableNoList.Contains(Format(InterfaceTableLink."Parent Table No.")) then
                            TableNoList.Add(Format(InterfaceTableLink."Parent Table No."));
                    until InterfaceTableLink.Next() = 0;

                foreach TableNo in TableNoList do begin
                    TableNoFilterText += '''' + TableNo + '''|';
                end;
                TableNoFilterText := TableNoFilterText.TrimEnd('|');
                If TableNoFilterText <> '' then begin
                    AllObj.Reset();
                    AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                    AllObj.SetFilter("Object ID", TableNoFilterText);
                    If Page.RunModal(Page::"All Objects with Caption", AllObj) = Action::LookupOK then
                        "Link Table No." := AllObj."Object ID";
                end;
            end;
        }

        field(6; "Link Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Link Field No." <> 0 then begin
                    Field.Get("Link Table No.", "Link Field No.");
                    "Link Field Name" := Field.FieldName;
                end;
            end;

        }
        field(7; "Link Field Name"; Text[30])
        {
            trigger OnLookup()
            var
                FieldList: Record Field;
            begin
                FieldList.Reset();
                FieldList.SetRange(TableNo, "Link Table No.");
                If Page.RunModal(Page::"Fields Lookup", FieldList) = Action::LookupOK then
                    validate("Link Field No.", FieldList."No.");

            end;
        }
        field(8; "Reference Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Reference Field No." <> 0 then begin
                    Field.Get("Parent Table No.", "Reference Field No.");
                    "Reference Field Name" := Field.FieldName;
                end;
            end;

        }
        field(9; "Reference Field Name"; Text[30])
        {
            trigger OnLookup()
            var
                FieldList: Record Field;
            begin
                FieldList.Reset();
                FieldList.SetRange(TableNo, "Parent Table No.");
                If Page.RunModal(Page::"Fields Lookup", FieldList) = Action::LookupOK then
                    validate("Reference Field No.", FieldList."No.");
            end;
        }
        field(10; "Reference Name"; Text[30])
        {

        }

    }
    keys
    {
        key(pk; "Interface Code", "Parent Table No.", "Link Table No.", "Reference Field No.", "Link Field No.")
        {
            Clustered = true;
        }
    }
}