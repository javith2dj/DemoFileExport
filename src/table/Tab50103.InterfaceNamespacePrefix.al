table 50103 "Interface Namespace/Prefix"
{
    fields
    {
        field(1; "Interface Code"; Code[20])
        {

        }
        field(2; Prefix; Text[10])
        {

        }
        field(3; "Namespace"; Text[1024])
        {

        }
    }
    keys
    {
        key(PK; "Interface Code", Prefix)
        {
            Clustered = true;
        }
    }
}