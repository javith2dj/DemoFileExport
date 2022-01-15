page 50100 "Mapping Setup"
{
    PageType = ListPart;
    SourceTable = "Dyn. Export Buffer";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Level; Rec.Level)
                {
                    ToolTip = 'Specifies the value of the Level field.';
                    ApplicationArea = All;
                }
                field("Node Type"; Rec."Node Type")
                {
                    ToolTip = 'Specifies the value of the Node Type field.';
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.';
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                    ApplicationArea = All;
                }
                field("Node Name"; Rec."Node Name")
                {
                    ToolTip = 'Specifies the value of the Node Name field.';
                    ApplicationArea = All;
                }
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
                field("Parent Node Name"; Rec."Parent Node Name")
                {
                    ToolTip = 'Specifies the value of the Parent Node Name field.';
                    ApplicationArea = All;
                }
                field("Alias Source Name"; Rec."Alias Source Name")
                {
                    ToolTip = 'Specifies the value of the Alias Source Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
