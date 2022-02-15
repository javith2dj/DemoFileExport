table 50102 "Interface Line Attributes"
{
    Caption = 'Interface Line Attributes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Interface Code"; Code[30])
        {
            Caption = 'Interface Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Attribute Key"; Text[30])
        {
            Caption = 'Attribute Key';
            DataClassification = ToBeClassified;
        }
        field(4; "Attribute Value"; Text[1024])
        {
            Caption = 'Attribute Value';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                AllObj: Record AllObjWithCaption;
                FieldList: Record "Interface Table Fields";
                InterfaceTableLink: Record "Interface Link Table";
                FunctionList: Record "Interface Functions";
                TableNoList: List of [Text];
                TableNoFilterText: Text;
                TableNo: Text;

            begin
                if "Attribute Type" = "Attribute Type"::"Field Element" then
                    if FieldList.FindSet() then
                        If Page.RunModal(Page::"Interface Field List", FieldList) = Action::LookupOK then begin
                            validate("Table No.", FieldList."Table No.");
                            validate("Field No.", FieldList."Field No.");
                            "Reference Name" := FieldList."Reference Name";
                        end;

                if "Attribute Type" = "Attribute Type"::"Function Element" then begin
                    FunctionList.Reset();
                    if Page.RunModal(Page::"Interface Function List", FunctionList) = Action::LookupOK then begin
                        "Attribute Value" := FunctionList."Function Code";
                    end;
                end
            end;
        }
        field(5; "Attribute Type"; enum "XML Attribute Type")
        {
            Caption = 'Attribute Type';
            DataClassification = ToBeClassified;
        }
        field(6; "Table No."; Integer)
        {
            trigger OnValidate()
            var
                AllObj: Record AllObj;
                Field: Record Field;
                TableObjectList: Page "Table Objects";
            begin
                If "Table No." <> 0 then begin
                    AllObj.Get(AllObj."Object Type"::TableData, "Table No.");
                    "Attribute Value" := AllObj."Object Name";
                    "Reference Name" := "Node Name";
                end;
            end;
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
                    "Attribute Value" := Field.FieldName;
                end;
            end;
        }
        field(8; "Reference Name"; Text[30])
        {

        }
        field(9; "Node Name"; Text[50])
        {

        }
        field(10; "Not Blank"; Boolean)
        {

        }
    }
    keys
    {
        key(PK; "Interface Code", "Line No.", "Attribute Key")
        {
            Clustered = true;
        }
    }
}
