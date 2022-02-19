table 50107 "Interface Functions"
{
    fields
    {
        field(1; "Function Code"; Code[50])
        {

        }
        field(2; Description; Text[250])
        {

        }
        field(3; "Return Table No."; Integer)
        {

        }
        field(4; "Return Table Name"; Text[30])
        {

        }
    }

    keys
    {
        key(PK; "Function Code")
        {
            Clustered = true;
        }
    }
}