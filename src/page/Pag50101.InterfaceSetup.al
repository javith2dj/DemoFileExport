page 50101 "Interface Setup"
{
    Caption = 'Interface Setup';
    PageType = Card;
    SourceTable = "Interface Header";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Folder Location"; Rec."Folder Location")
                {
                    ToolTip = 'Specifies the value of the Folder Location field.';
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                    ApplicationArea = All;
                }
                field("Archive Folder"; Rec."Archive Folder")
                {
                    ToolTip = 'Specifies the value of the Archive Folder field.';
                    ApplicationArea = All;
                }
            }

            part("Interface Mapping"; "Interface Mapping ListPart")
            {
                SubPageLink = "Interface Code" = field("Interface Code");
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Namepace)
            {
                ApplicationArea = All;
                Caption = 'Namespace';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Line;
                RunObject = page "Interface Namespace";
                RunPageLink = "Interface Code" = field("Interface Code");
            }
        }
    }

}
