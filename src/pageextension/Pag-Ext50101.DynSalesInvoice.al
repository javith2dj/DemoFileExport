pageextension 50101 "Dyn. Sales Invoice" extends "Posted Sales Invoice"
{
    actions
    {
        addlast(processing)
        {
            action("ExportXML")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ExportCodeunit: Codeunit "Export Invoice";
                begin
                    ExportCodeunit.Run(Rec);
                end;
            }
        }

    }
}
