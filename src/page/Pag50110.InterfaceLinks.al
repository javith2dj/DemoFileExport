page 50110 "Interface Links"
{
    ApplicationArea = All;
    Caption = 'Interface Links';
    PageType = List;
    SourceTable = "Interface Link Table";
    UsageCategory = Lists;
    
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
                field("Parent Table No."; Rec."Parent Table No.")
                {
                    ToolTip = 'Specifies the value of the Parent Table No. field.';
                    ApplicationArea = All;
                }
                field("Parent Table Name"; Rec."Parent Table Name")
                {
                    ToolTip = 'Specifies the value of the Parent Table Name field.';
                    ApplicationArea = All;
                }
                field("Link Table No."; Rec."Link Table No.")
                {
                    ToolTip = 'Specifies the value of the Link Table No. field.';
                    ApplicationArea = All;
                }
                field("Link Table Name"; Rec."Link Table Name")
                {
                    ToolTip = 'Specifies the value of the Link Table Name field.';
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
                field("Parent Field No."; Rec."Parent Field No.")
                {
                    ToolTip = 'Specifies the value of the Parent Field No. field.';
                    ApplicationArea = All;
                }
                field("Parent Field Name"; Rec."Parent Field Name")
                {
                    ToolTip = 'Specifies the value of the Parent Field Name field.';
                    ApplicationArea = All;
                }
                field("Parent Reference Name"; Rec."Parent Reference Name")
                {
                    ToolTip = 'Specifies the value of the Parent Reference Name field.';
                    ApplicationArea = All;
                }
                field("Link Reference Name"; Rec."Link Reference Name")
                {
                    ToolTip = 'Specifies the value of the Link Reference Name field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
