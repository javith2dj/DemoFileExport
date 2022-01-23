page 50104 "Interface Link Table"
{
    Caption = 'Interface Link Table';
    PageType = List;
    SourceTable = "Interface Link Table";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Parent Table Name"; Rec."Parent Table Name")
                {
                    ApplicationArea = All;
                }
                field("Reference Field Name"; Rec."Parent Field Name")
                {
                    ApplicationArea = All;
                }
                field("Link Table Name"; Rec."Link Table Name")
                {
                    ApplicationArea = All;
                }
                field("Link Field Name"; Rec."Link Field Name")
                {
                    ToolTip = 'Specifies the value of the Link Field Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
