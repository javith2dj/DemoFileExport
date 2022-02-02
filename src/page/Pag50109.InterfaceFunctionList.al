page 50109 "Interface Function List"
{
    ApplicationArea = All;
    Caption = 'Interface Function List';
    PageType = List;
    SourceTable = "Interface Functions";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Function Code"; Rec."Function Code")
                {
                    ToolTip = 'Specifies the value of the Function Code field.';
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
