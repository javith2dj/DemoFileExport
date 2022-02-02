table 50100 "Interface Line"
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
        field(4; "Node Name"; Text[50])
        {

        }
        field(5; "Node Type"; enum "XML Node Type")
        {

        }
        field(6; Source; Text[50])
        {
            trigger OnLookup()
            var
                AllObj: Record AllObjWithCaption;
                FieldList: Record "Interface Table Fields";
                InterfaceTableLink: Record "Interface Link Table";
                TableNoList: List of [Text];
                TableNoFilterText: Text;
                TableNo: Text;

            begin
                if "Node Type" = "Node Type"::"Table Element" then begin
                    AllObj.Reset();
                    AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                    If Page.RunModal(Page::"All Objects with Caption", AllObj) = Action::LookupOK then
                        validate("Table No.", AllObj."Object ID");
                end;

                if "Node Type" = "Node Type"::"Field Element" then
                    if FieldList.FindSet() then
                        If Page.RunModal(Page::"Interface Field List", FieldList) = Action::LookupOK then begin
                            validate("Table No.", FieldList."Table No.");
                            validate("Field No.", FieldList."Field No.");
                            "Reference Name" := FieldList."Reference Name";
                        end;
            end;
        }
        field(7; Prefix; Text[30])
        {
            TableRelation = "Interface Namespace/Prefix".Prefix where("Interface Code" = field("Interface Code"));
        }
        field(8; "Parent Node Name"; Text[50])
        {

        }
        field(9; "Table No."; Integer)
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
                    "Reference Name" := "Node Name";
                end;
            end;
        }
        field(10; "Field No."; Integer)
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
        }
        field(11; "Reference Name"; Text[30])
        {

        }
        field(12; "Parent"; Boolean)
        {

        }
        field(13; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'Text,Date,Decimal,DateTime';
            OptionMembers = Text,Date,Decimal,DateTime;
        }
        field(14; "Data Format"; Text[100])
        {

        }
        field(15; "Data Formatting Culture"; Text[100])
        {

        }
        field(16; "Negative-Sign Identifier"; Text[30])
        {
            Caption = 'Negative-Sign Identifier';
        }
        field(17; Multiplier; Decimal)
        {
            Caption = 'Multiplier';
            InitValue = 1;

            trigger OnValidate()
            begin
                if IsValidToUseMultiplier and (Multiplier = 0) then
                    Error(ZeroNotAllowedErr);
            end;
        }
        field(18; "Transformation Rule"; Code[20])
        {
            Caption = 'Transformation Rule';
            TableRelation = "Transformation Rule";
        }
        field(19; "Overwrite Value"; Boolean)
        {
            Caption = 'Overwrite Value';
        }
    }

    keys
    {
        Key(PK; "Interface Code", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        ZeroNotAllowedErr: Label 'All numeric values are allowed except zero.';

    trigger OnInsert()
    var
        InterfaceTables: Record "Interface Tables";
        LinkFieldsRec: Record "Interface Table Fields";
        FieldsRec: Record Field;
    begin
        If ("Node Type" = "Node Type"::"Table Element") and ("Table No." <> 0) then begin
            InterfaceTables.Init();
            InterfaceTables."Interface Code" := "Interface Code";
            InterfaceTables."Reference Name" := "Reference Name";
            InterfaceTables."Table No" := "Table No.";
            InterfaceTables."Table Name" := Source;
            if InterfaceTables.Insert() then begin
                FieldsRec.SetRange(TableNo, "Table No.");
                If FieldsRec.FindSet() then
                    repeat
                        LinkFieldsRec.Init();
                        LinkFieldsRec."Interface Code" := "Interface Code";
                        LinkFieldsRec."Reference Name" := "Reference Name";
                        LinkFieldsRec."Table No." := FieldsRec.TableNo;
                        LinkFieldsRec."Table Name" := FieldsRec.TableName;
                        LinkFieldsRec."Field No." := FieldsRec."No.";
                        LinkFieldsRec."Field Name" := FieldsRec.FieldName;
                        LinkFieldsRec.Insert();
                    until FieldsRec.Next() = 0;
            end;
        end;
    end;

    trigger OnModify()
    var
        InterfaceTables: Record "Interface Tables";
        LinkFieldsRec: Record "Interface Table Fields";
        FieldsRec: Record Field;
    begin
        If ("Node Type" = "Node Type"::"Table Element") and ("Table No." <> 0) then begin
            InterfaceTables.Init();
            InterfaceTables."Interface Code" := "Interface Code";
            InterfaceTables."Reference Name" := "Reference Name";
            InterfaceTables."Table No" := "Table No.";
            InterfaceTables."Table Name" := Source;
            if InterfaceTables.Insert() then begin
                FieldsRec.SetRange(TableNo, "Table No.");
                If FieldsRec.FindSet() then
                    repeat
                        LinkFieldsRec.Init();
                        LinkFieldsRec."Interface Code" := "Interface Code";
                        LinkFieldsRec."Reference Name" := "Reference Name";
                        LinkFieldsRec."Table No." := FieldsRec.TableNo;
                        LinkFieldsRec."Table Name" := FieldsRec.TableName;
                        LinkFieldsRec."Field No." := FieldsRec."No.";
                        LinkFieldsRec."Field Name" := FieldsRec.FieldName;
                        LinkFieldsRec.Insert();
                    until FieldsRec.Next() = 0;
            end;
        end;
    end;

    local procedure IsValidToUseMultiplier(): Boolean
    begin
        exit("Data Type" = "Data Type"::Decimal);
    end;
}