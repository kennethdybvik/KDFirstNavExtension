// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App RE-published: Hello world');
    end;
}
pageextension 50101 CustomerSaveExt extends "Customer Card"
{
    trigger OnModifyRecord(): Boolean
    begin
        If (Rec."Language Code" <> 'NOR') and (Rec."Language Code" <> '')  then
          Error('Language must be NOR or empty.');
    end;

}

codeunit 50100 test1 {
   EventSubscriberInstance = StaticAutomatic;
   [EventSubscriber(ObjectType::Codeunit, Codeunit::Mail, 
    'OnBeforeCreateMessage', '', true, true)]
    procedure CheckMessage();
    var
    line : Text;
    xmlbuf : Record "XML Buffer";
    tmpBlob : Record TempBlob;
    basicAuth : Text;
    auth : Text;
    begin
        if (STRPOS(line, '+') > 0) then begin
            xmlbuf.LoadFromText(line);
            auth := 'Username' + 'Password';
            tmpBlob.WriteAsText(auth,TextEncoding::Windows);
            basicAuth := tmpBlob.ToBase64String();
            MESSAGE('Cannot use a plus sign (+) in the address [' + line + ']');
        end;
    end;
}
