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
        }
    }
    keys
    {
        key(PK; "Interface Code","Line No.","Attribute Key")
        {
            Clustered = true;
        }
    }
}
