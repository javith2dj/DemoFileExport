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
                field("Parent Table No."; Rec."Parent Table No.")
                {
                    ToolTip = 'Specifies the value of the Parent Table No. field.';
                    ApplicationArea = All;
                }
                field("Link Table No."; Rec."Link Table No.")
                {
                    ToolTip = 'Specifies the value of the Link Table No. field.';
                    ApplicationArea = All;
                }
                field("Link Field No."; Rec."Link Field No.")
                {
                    ToolTip = 'Specifies the value of the Link Field No. field.';
                    ApplicationArea = All;
                }
                field("Link Field Name"; Rec."Link Field Name")
                {
                    ToolTip = 'Specifies the value of the Link Field Name field.';
                    ApplicationArea = All;
                }
                field("Parent Field No."; Rec."Reference Field No.")
                {
                    ToolTip = 'Specifies the value of the Parent Field No. field.';
                    ApplicationArea = All;
                }
                field("Reference Field Name"; Rec."Reference Field Name")
                {
                    ToolTip = 'Specifies the value of the Reference Field Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
