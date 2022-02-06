page 50108 "Interface Line Attributes"
{
    Caption = 'Interface Line Attributes';
    PageType = List;
    SourceTable = "Interface Line Attributes";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Attribute Key"; Rec."Attribute Key")
                {
                    ToolTip = 'Specifies the value of the Attribute Key field.';
                    ApplicationArea = All;
                }
                field("Attribute Type"; Rec."Attribute Type")
                {
                    ApplicationArea = All;
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    ToolTip = 'Specifies the value of the Attribute Value field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Node Name" := Rec.GetFilter("Node Name");
    end;
}
