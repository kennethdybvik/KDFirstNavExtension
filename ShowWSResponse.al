table 50100 WSResponse
{
    Caption = 'WSResponse';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;ID; BigInteger)
        {
            Description = 'ID for content';
            AutoIncrement = true;
            
        }
        field(2;URL; Text[100])
        {
            Description = 'URL for webservice called.';
            
        }
        field(3;Response; Blob)
        {
            Description = 'The response after ws call.';
            
        }
    }
    
    keys
    {
        key(PK; ID)
        {
            Clustered = false;
        }
    }
    
    var
        myInt: Integer;
    
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}

page 50101 WSCall
{
    PageType = Card;
    UsageCategory = Administration;            
    layout
    {
        area(content)
        {
            group(General)
            {
                field(URL;txtURL)
                {
                   Caption = 'URL';
                   ApplicationArea = All;
                }
                field(Response;txtRes)
                {
                   Caption = 'Response';
                   ApplicationArea = All;
                   MultiLine = true;
                }
                
            }
         
        }
    }
    
    actions
    {
        area(Processing)
        {
            
            action(GetResponse)
            {
              Promoted = true;
              ApplicationArea = All;
              PromotedCategory = Process;
              
              Caption = 'Get WS response';
              trigger OnAction()
              begin
                  if (StrLen(txtURL) > 0) then begin
                    CallWebservice(txtURL);
                    wsRes.SetRange(URL,txtURL);
                    if wsRes.FindFirst() then
                    begin
                       wsRes.CalcFields(Response);
                       wsRes.Response.CreateInStream(resStream);
                       resText.Read(resStream);
                       resText.GetSubText(txtRes,1,resText.Length);
                    end;
                  end
                  else
                    Message('You must enter a URL.');
              end;

            }
        }
    }
    
    var
        txtURL : Text;
        txtRes : Text;
        wsMgt: Codeunit WServiceManagement;
        wsRes : Record WSResponse;
        resText : BigText;
        resStream : InStream;

        local procedure CallWebservice(tURL: Text[150]); begin
          wsMgt.CallWebservice(tURL);
        end;
}
page 50100 ShowWSResponse
{
    PageType = List;
    SourceTable = WSResponse; 
    Caption = 'Webservice result';    
    Description = 'Show response for call to webservices.';
    UsageCategory = Lists;
    ApplicationArea = All;
    
            
    layout
    {
        area(content)
        {
            repeater("URL List") 
            {             
                field(URL; URL)
                {
                    ApplicationArea = All;
                }
                field(Response; Response)
                {
                    ApplicationArea = All;
                } 
                

            }
        }
        
    }
    
    actions
    {
        area(Processing)
        {
            action(test) {
                Caption='Testing';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction() begin
                    //Message('testing');
                    Page.Run(50101);
                end;
            }
        }
    }
 
}
codeunit 50101 WServiceManagement {
    procedure CallWebservice(txtURL: Text[150]);
    var
    wsResponse : Record WSResponse;
    xHttpClient: HttpClient;
    xResponseMsg: HttpResponseMessage;
    xmlbuf : Record "XML Buffer";
    tmpBlob : Record TempBlob;
    basicAuth : Text;
    auth : Text;
    responseText: Text;
    responseStream : OutStream;
    wsStream : InStream;
    begin
        if (StrLen(txtURL) > 0) then begin
            wsResponse.Init;
            wsResponse.URL := txtURL;
            wsResponse.Response.CreateOutStream(responseStream,TextEncoding::UTF8);
            xHttpClient.DefaultRequestHeaders.Add('User-Agent','Dynamics365');
            if (xHttpClient.Get(txtURL,xResponseMsg)) then begin
              xResponseMsg.Content.ReadAs(wsStream);
              wsStream.ReadText(responseText);
              responseStream.Write(responseText);
              wsResponse.Insert;
              
              //Page.Run(50100,wsResponse);
            end;
        end;
    end;
[EventSubscriber(ObjectType::Page, Page::ShowWSResponse, 'OnAfterGetRecordEvent', '',true, true)]
local procedure MyProcedure(var Rec: Record WSResponse)
begin
    
end;

}