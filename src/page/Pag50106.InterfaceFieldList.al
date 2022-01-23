page 50106 "Interface Field List"
{
    Caption = 'Interface Field List';
    PageType = List;
    SourceTable = "Interface Table Fields";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Reference Name"; Rec."Reference Name")
                {
                    ToolTip = 'Specifies the name of the table.';
                    ApplicationArea = All;
                }
                field(FieldName; Rec."Field Name")
                {
                    ToolTip = 'Specifies the name of the field in the table.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
