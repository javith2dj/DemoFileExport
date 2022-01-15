table 50101 "Interface Header"
{

    LookupPageId = "Interface List";

    FIELDS
    {
        field(1; "Interface Code"; Code[20])
        {

        }

        field(2; Description; Text[50])
        {

        }

        field(4; "Folder Location"; Text[250])
        {

        }

        field(5; "File Name"; Text[250])
        {

        }
        field(6; "Archive Folder"; Text[250])
        {

        }
    }
    KEYS
    {
        Key(PK; "Interface Code")
        {
            Clustered = true;
        }
    }
}