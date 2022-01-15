page 50102 "Interface List"
{
    ApplicationArea = All;
    Caption = 'Interface List';
    PageType = List;
    SourceTable = "Interface Header";
    UsageCategory = Lists;
    CardPageId = "Interface Setup";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Interface Code"; Rec."Interface Code")
                {
                    ToolTip = 'Specifies the value of the Interface Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
