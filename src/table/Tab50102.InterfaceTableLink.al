table 50102 "Interface Table Link"
{
    fields
    {
        field(1; "Interface Code"; Code[20])
        {

        }
        field(2; "Table No."; Integer)
        {
            trigger OnLookup()
            var
                AllObj: Record AllObjWithCaption;
            begin
                AllObj.Reset();
                AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                If Page.RunModal(Page::"All Objects with Caption", AllObj) = Action::LookupOK then
                    "Table No." := AllObj."Object ID";

            end;
        }
        field(3; "Table Line No."; Integer)
        {

        }
        field(4; "Parent Table No."; Integer)
        {
            trigger OnLookup()
            var
                AllObj: Record AllObjWithCaption;
            begin
                AllObj.Reset();
                AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                If Page.RunModal(Page::"All Objects with Caption", AllObj) = Action::LookupOK then
                    "Parent Table No." := AllObj."Object ID";

            end;
        }
        field(5; "Parent Line No."; Integer)
        {

        }
        field(6; "Line No."; Integer)
        {

        }
        field(7; "Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Field No." <> 0 then begin
                    Field.Get("Table No.", "Field No.");
                    "Field Name" := Field.FieldName;
                end;
            end;

            trigger OnLookup()
            var
                FieldList: Record Field;
            begin
                FieldList.Reset();
                FieldList.SetRange(TableNo, "Table No.");
                If Page.RunModal(Page::"Fields Lookup", FieldList) = Action::LookupOK then
                    validate("Field No.", FieldList."No.");

            end;
        }
        field(8; "Field Name"; Text[30])
        {

        }
        field(9; "Reference Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Field No." <> 0 then begin
                    Field.Get("Parent Table No.", "Reference Field No.");
                    "Reference Field Name" := Field.FieldName;
                end;
            end;

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
        field(10; "Reference Field Name"; Text[30])
        {

        }
    }

    keys
    {
        Key(PK; "Interface Code", "Table No.", "Table Line No.", "Parent Table No.", "Parent Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    VAR
        TableFields: Record Field;
        Text001: Label 'Invalid field number.;';

}