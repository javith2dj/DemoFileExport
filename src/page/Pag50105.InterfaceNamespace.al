page 50105 "Interface Namespace"
{
    Caption = 'Interface Namespace';
    PageType = List;
    SourceTable = "Interface Namespace/Prefix";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Prefix; Rec.Prefix)
                {
                    ToolTip = 'Specifies the value of the Prefix field.';
                    ApplicationArea = All;
                }
                field(Namespace; Rec.Namespace)
                {
                    ToolTip = 'Specifies the value of the Namespace field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
