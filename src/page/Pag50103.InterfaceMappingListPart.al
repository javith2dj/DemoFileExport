page 50103 "Interface Mapping ListPart"
{
    Caption = 'Interface Mapping';
    PageType = ListPart;
    SourceTable = "Interface Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                IndentationColumn = NameIndent;
                IndentationControls = "Node Name";
                field("Node Name"; Rec."Node Name")
                {
                    ToolTip = 'Specifies the value of the Node Name field.';
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    Width = 50;
                }
                field("Node Type"; Rec."Node Type")
                {
                    ToolTip = 'Specifies the value of the Node Type field.';
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                    ApplicationArea = All;
                }

                field(Prefix; Rec.Prefix)
                {
                    ToolTip = 'Specifies the value of the Prefix field.';
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

    actions
    {
        area(Processing)
        {
            action("Link Table")
            {
                ApplicationArea = All;
                Caption = 'Link Table';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Line;
                RunObject = page "Interface Link Table";
                RunPageLink = "Interface Code" = field("Interface Code"),
                                "Parent Table No." = field("Table No."),
                                "Reference Name" = field("Node Name");
            }
            action("Right")
            {
                ApplicationArea = All;
                Caption = 'Right Indent';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = IndentChartOfAccounts;

                trigger OnAction()
                begin
                    Rec.Level += 1;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Left")
            {
                ApplicationArea = All;
                Caption = 'Left Indent';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Indent;

                trigger OnAction()
                begin
                    If (Rec.Level = 1) then
                        exit;

                    Rec.Level -= 1;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := Rec.Level;
        NameEmphasize := (Rec."Node Type" = Rec."Node Type"::"Table Element") or (Rec.Level = 0);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NameIndent := 0;
        NameEmphasize := (Rec."Node Type" = Rec."Node Type"::"Table Element") or (Rec.Level = 0);
    end;

    var
        [InDataSet]
        NameIndent: Integer;
        [InDataSet]
        NameEmphasize: Boolean;
}
