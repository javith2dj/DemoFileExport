table 50106 "Interface Tables"
{
    Caption = 'Interface Tables';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Interface Code"; Code[30])
        {
            Caption = 'Interface Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Reference Name"; Text[30])
        {
            Caption = 'Reference Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Table No"; Integer)
        {
            Caption = 'Table No';
            DataClassification = ToBeClassified;
        }
        field(4; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Interface Code", "Reference Name")
        {
            Clustered = true;
        }
    }
}
