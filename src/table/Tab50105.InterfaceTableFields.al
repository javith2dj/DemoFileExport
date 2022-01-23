table 50105 "Interface Table Fields"
{
    Caption = 'Interface Link Table Fields';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Interface Code"; Code[30])
        {
            Caption = 'Interface Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No';
            DataClassification = ToBeClassified;
        }
        field(4; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Field No."; Integer)
        {
            Caption = 'Field No';
            DataClassification = ToBeClassified;
        }
        field(6; "Reference Name"; Text[30])
        {
            Caption = 'Reference Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Interface Code", "Reference Name", "Field No.")
        {
            Clustered = true;
        }
    }
}
