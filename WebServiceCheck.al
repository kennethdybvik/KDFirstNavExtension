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
        field(2;URL; Text[250])
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
            usercontrol(googleMap;GoogleMapCtrl) {
                    trigger ControlReady();
                begin
                    MapIsReady := true;
                end;
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
                       ShowAddress(txtRes);
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
        MapIsReady : Boolean;

        local procedure CallWebservice(tURL: Text[250]); begin
          wsMgt.CallWebservice(tURL);
        end;
        local procedure ShowAddress(addressTxt : Text[250]);
        var
          CustAddress: Text;
        begin
          if not MapIsReady then
            exit;

        CurrPage.googleMap.ShowAddress(addressTxt);
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
                Caption='Webservice Card';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction() begin
                    Page.Run(50101);
                end;
            }
        }
    }
 
}

controladdin GoogleMapCtrl
{
    Scripts = 'https://maps.googleapis.com/maps/api/js',
              'scripts/googlemap.js';
    StartupScript = 'scripts/start.js';
    
    RequestedHeight = 300;
    RequestedWidth = 300;
    MinimumHeight = 250;
    MinimumWidth = 250;
    MaximumHeight = 500;
    MaximumWidth = 500;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;
    event ControlReady();
    procedure ShowAddress(Address: Text);
}

codeunit 50101 WServiceManagement 
{
    procedure CallWebservice(txtURL: Text[250]);
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
}