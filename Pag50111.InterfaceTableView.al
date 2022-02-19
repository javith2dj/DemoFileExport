page 50111 "Interface Table View"
{
    ApplicationArea = All;
    Caption = 'Interface Table View';
    PageType = List;
    SourceTable = "Interface Table View";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Reference Name"; Rec."Reference Name")
                {
                    ToolTip = 'Specifies the value of the Reference Name field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
