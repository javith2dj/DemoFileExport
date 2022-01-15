table 50100 "Dyn. Export Buffer"
{
    fields
    {
        field(1; "Interface Code"; Text[30])
        {
            TableRelation = "Interface Header"."Interface Code";
        }
        field(2; "Line No."; Integer)
        {

        }
        field(3; Level; Integer)
        {

        }
        field(4; "Node Type"; enum "XML Node Type")
        {

        }
        field(5; "Source Type"; enum "Mapping Source Type")
        {

        }
        field(6; Source; Text[50])
        {

        }
        field(7; "Node Name"; Text[50])
        {

        }
        field(8; Prefix; Text[30])
        {
            TableRelation = "Interface Namespace/Prefix".Prefix where("Interface Code" = field("Interface Code"));
        }
        field(9; Namespace; Text[1024])
        {

        }
        field(10; "Parent Node Name"; Text[50])
        {

        }
        field(11; "Table No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Table Objects";
            begin
                If "Table No." <> 0 then begin
                    AllObj.Get(AllObj."Object Type"::TableData, "Table No.");
                    Source := AllObj."Object Name";
                end;
            end;

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
        field(12; "Field No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Fields Lookup";
            begin
                If "Field No." <> 0 then begin
                    Field.Get("Table No.", "Field No.");
                    Source := Field.FieldName;
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
        field(13; "Alias Source Name"; Boolean)
        {

        }
    }

    keys
    {
        Key(PK; "Interface Code", "Line No.")
        {
            Clustered = true;
        }
    }
}