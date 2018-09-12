pageextension 50102 ItemCardExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        modify("No.") {
          CaptionML=ENU='INo:',NOR='VNr:';
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}