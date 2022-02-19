table 50108 "Interface Table View"
{
    Caption = 'Interface Table View';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Interface Code"; Code[20])
        {
            Caption = 'Interface Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Reference Name"; Text[30])
        {
            Caption = 'Reference Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Value"; Text[1024])
        {
            Caption = 'Value';
            DataClassification = ToBeClassified;
        }
        field(7; "Field Name"; Text[30])
        {
            trigger OnLookup()
            var
                FieldList: Record Field;
            begin
                FieldList.Reset();
                FieldList.SetRange(TableNo, "Table No.");
                If Page.RunModal(Page::"Fields Lookup", FieldList) = Action::LookupOK then begin
                    validate("Field No.", FieldList."No.");
                    "Field Name" := FieldList.FieldName;
                end;

            end;
        }
    }
    keys
    {
        key(PK; "Interface Code", "Reference Name", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }
}
