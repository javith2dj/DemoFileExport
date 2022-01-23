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
                InterfaceTables: Record "Interface Tables";
                InterfaceTableLink: Record "Interface Link Table";
                TableNoList: List of [Text];
                TableNoFilterText: Text;
                TableNo: Text;
            begin
                If InterfaceTables.Findset then
                    If Page.RunModal(Page::"Interface Tables", InterfaceTables) = Action::LookupOK then begin
                        "Link Table No." := InterfaceTables."Table No";
                        "Link Table Name" := InterfaceTables."Table Name";
                        "Link Reference Name" := InterfaceTables."Reference Name";
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
        field(8; "Parent Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Parent Field No." <> 0 then begin
                    Field.Get("Parent Table No.", "Parent Field No.");
                    "Parent Field Name" := Field.FieldName;
                end;
            end;

        }
        field(9; "Parent Field Name"; Text[30])
        {
            trigger OnLookup()
            var
                FieldList: Record Field;
            begin
                FieldList.Reset();
                FieldList.SetRange(TableNo, "Parent Table No.");
                If Page.RunModal(Page::"Fields Lookup", FieldList) = Action::LookupOK then
                    validate("Parent Field No.", FieldList."No.");
            end;
        }
        field(10; "Parent Reference Name"; Text[30])
        {

        }
        field(11; "Link Reference Name"; Text[30])
        {

        }
    }
    keys
    {
        key(pk; "Interface Code", "Parent Table No.", "Link Table No.", "Parent Field No.", "Link Field No.")
        {
            Clustered = true;
        }
    }
}