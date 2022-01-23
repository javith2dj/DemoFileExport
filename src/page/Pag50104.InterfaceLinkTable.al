page 50104 "Interface Link Table"
{
    Caption = 'Interface Link Table';
    PageType = List;
    SourceTable = "Interface Link Table";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Reference Field Name"; Rec."Parent Field Name")
                {
                    ApplicationArea = All;
                }
                field("Link Table Name"; Rec."Link Table Name")
                {
                    ApplicationArea = All;
                }
                field("Link Field Name"; Rec."Link Field Name")
                {
                    ToolTip = 'Specifies the value of the Link Field Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Parent Table Name" := Rec.GetFilter("Parent Table Name");
        Rec."Parent Reference Name" := Rec.GetFilter("Parent Reference Name");
    end;
}
