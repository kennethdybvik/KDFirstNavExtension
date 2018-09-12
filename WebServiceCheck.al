table 50100 WSResponse
{
    Caption = 'WSResponse';
        
    fields
    {
        field(1;ID; BigInteger)
        {
            Description = 'ID for content';
            AutoIncrement = true;
            
        }
        field(2;URL; Text[250])
        {
            CaptionML=ENU='URL',NOR='URL';
            Description = 'URL for webservice called.';
            
        }
        field(3;Username; Text[30])
        {
            CaptionML=ENU='Username',NOR='Brukernavn';
            Description = 'Username to be able to access webservice (if neccessary).';
            
        }
        field(4;Password; Text[30])
        {
            CaptionML=ENU='Password',NOR='Passord';
            Description = 'Password to be able to access webservice (if neccessary).';
            
        }
        field(5;Authentication;Option)
        {
            OptionCaptionML = ENU='Anonymous,Basic,Windows',NOR='Anonym,Basic,Windows';
            OptionMembers = Anonymous,Basic,Windows;
            Description = 'Authentication: Anonymous,Basic or Windows';
            
        }

        field(6;Https;Boolean)
        {
            CaptionML = ENU='Https',NOR='Https';
            Description = 'Use Https (or Http if not checked).';
            
        }

        field(7;Response; Blob)
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
                   ApplicationArea = All;
                }
                field(Username;txtUsername) {
                  ApplicationArea = All;
                }
                field(Password;txtPassword) {
                    ApplicationArea = All;
                }
                field(Authentication;oAuthentication) {
                    OptionCaptionML=ENU='Anonymous,Basic,Windows',NOR='Anonymous,Basic,Windows';
                    ApplicationArea = All;
                }
                field(Https;bHttps) {
                    ApplicationArea = All;
                }
               
            }
                usercontrol(Response;RichText)
                {
                   ApplicationArea = All;
                   
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
                    CallWebservice(txtURL,txtUsername,txtPassword,oAuthentication,bHttps);
                    wsRes.SetRange(URL,txtURL);
                    if wsRes.FindFirst() then
                    begin
                       wsRes.CalcFields(Response);
                       wsRes.Response.CreateInStream(resStream);
                       resText.Read(resStream);
                       resText.GetSubText(txtRes,1,resText.Length);
                       txtStyle := 'position:fixed;width=900px;height=900px;margin:0px;padding:0px;overflow-wrap:break-word;font-family:Verdana;font-size:9px;font-weight:normal';
                       CurrPage.Response.addText(txtRes,txtStyle);
                    end;
                  end
                  else
                    Message('You must enter a URL (and Username/Password if required).');
              end;

            }
        }
    }
    
    var
        txtURL : Text;
        txtUsername : Text;
        txtPassword : Text;
        oAuthentication : Option;
        bHttps : Boolean;
        txtRes : Text;
        txtStyle : Text;
    
        wsMgt: Codeunit WServiceManagement;
        wsRes : Record WSResponse;
        resText : BigText;
        resStream : InStream;
        
        local procedure CallWebservice(tURL: Text[250];tUsername:Text;tPassword:Text;oAuthentication:Option;bHttps:Boolean); begin
          wsMgt.CallWebservice(tURL,tUsername,tPassword,oAuthentication,bHttps);
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
            }
        }
        
    }
    
    actions
    {
        area(Processing)
        {
            action(ShowCard) {
                Caption='Webservice Card';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction() begin
                    Page.Run(50101,Rec);
                end;
            }
        }
    }
 
}

controladdin RichText {
  Scripts = 'scripts/richText.js';
  StartupScript = 'scripts/richTextStart.js';
  //StyleSheets = 'scripts/css/RichText.css';
  
  VerticalStretch = false;
  HorizontalStretch = false;
  VerticalShrink = false;
  HorizontalShrink = false;

  RequestedHeight = 800;
  RequestedWidth = 875;
      
  procedure addText(txt: Text;style: Text)
}



codeunit 50101 WServiceManagement 
{
    procedure CallWebservice(URL: Text;Username:Text;Password:Text;Authentication:Integer;Https:Boolean);
    var
    wsResponse : Record WSResponse;
    xHttpClient: HttpClient;
    xResponseMsg: HttpResponseMessage;
    tmpBlob : Record TempBlob;
    basicAuth : Text;
    auth : Text;
    addRec : Boolean;
    inText : Text;
    int : Integer;

    responseText: Text;
    responseStream : OutStream;
    wsStream : InStream;
    begin
        addRec := False;
        if (StrLen(URL) > 0) then begin
            wsResponse.SetRange(URL,URL);
            if Not wsResponse.FindFirst then
              addRec := True;
            if addRec then
              wsResponse.Init;
            wsResponse.URL := URL;
            wsResponse.Response.CreateOutStream(responseStream,TextEncoding::UTF8);
            xHttpClient.DefaultRequestHeaders.Add('User-Agent','Dynamics365');
            xHttpClient.Timeout(30000);
            inText := '';
            responseText := '';
            if (xHttpClient.Get(URL,xResponseMsg)) then begin
              xResponseMsg.Content.ReadAs(wsStream);
              WHILE NOT (wsStream.EOS) DO BEGIN  
                int := wsStream.READTEXT(inText,1000);  
                responseText += inText;
              END;  
              //wsStream.ReadText(responseText);
              responseStream.Write(responseText);
              if addRec Then
                wsResponse.Insert
              else
                wsResponse.Modify;  
            end else begin
              Message('not able to get response.');
            end;
        end;
    end;
}