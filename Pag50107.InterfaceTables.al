page 50107 "Interface Tables"
{
    Caption = 'Interface Tables';
    PageType = List;
    SourceTable = "Interface Tables";
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
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
