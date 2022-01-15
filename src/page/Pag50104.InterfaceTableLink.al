page 50104 "Interface Table Link"
{
    Caption = 'Interface Table Link';
    PageType = List;
    SourceTable = "Interface Table Link";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.';
                    ApplicationArea = All;
                }
                field("Table Line No."; Rec."Table Line No.")
                {
                    ToolTip = 'Specifies the value of the Table Line No. field.';
                    ApplicationArea = All;
                }
                field("Parent Table No."; Rec."Parent Table No.")
                {
                    ToolTip = 'Specifies the value of the Parent Table No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Parent Line No."; Rec."Parent Line No.")
                {
                    ToolTip = 'Specifies the value of the Parent Line No. field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    ApplicationArea = All;
                }
                field("Reference Field No."; Rec."Reference Field No.")
                {
                    ToolTip = 'Specifies the value of the Reference Field No. field.';
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
