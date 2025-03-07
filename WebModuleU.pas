unit WebModuleU;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, DAO_Pessoa, DTO_Pessoa,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.UI, REST.JSON, System.JSON,
  ThreadAtualizaEnderecos;

type
  TWebModule1 = class(TWebModule)
    FDConnection: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1POSTPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1GETPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DELETEPessoaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1PATCHPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ExecutaIntegradorAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1PessoasLoteAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' +
    '</html>';
end;

function AtualizarEnderecos(): System.Boolean;
var
  NewThread: TCepIntegracao;
begin
  NewThread := TCepIntegracao.Create(false);
  NewThread.FreeOnTerminate := True;
  while not(NewThread.Finished) do
  begin
    result := NewThread.Finished;
  end;
  result := NewThread.Finished;
end;

procedure TWebModule1.WebModule1DELETEPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDaoPessoa: TDaoPessoa;
  LDtoPessoa: TDtoPessoa;
  LIdPessoa: System.Integer;
begin
  LIdPessoa := Request.QueryFields.Values['idpessoa'].ToInteger;
  LDtoPessoa := TDtoPessoa.Create();
  LDaoPessoa := TDaoPessoa.Create(FDConnection);
  try
    try 
      LDaoPessoa.SafeDelete(LIdPessoa);
      Response.StatusCode := 200;
      Response.Content := '{"message": "Registro excluido com sucesso."}';
    except
      on e: Exception do
      begin
        Response.StatusCode := 501;
        Response.Content := '{"message": "Erro ao excluir o  recurso." erro: "'+e.Message+'"}';
      end;       
    end;              
  finally
    LDtoPessoa.Free;
    LDaoPessoa.Free;
  end;
end;

procedure TWebModule1.WebModule1ExecutaIntegradorAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  try
    if(AtualizarEnderecos()) then
    begin
      Response.StatusCode := 200;
      Response.Content := '{"message": "Integrador executado com sucesso."}';
    end;
  except
    on e:Exception do
    begin
      Response.StatusCode := 501;
      Response.Content := '{"message": "Erro ao executar o integrador", messageErro: "'+e.Message+'"}';
    end;
  end;

end;

procedure TWebModule1.WebModule1GETPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDaoPessoa: TDaoPessoa;
  LDtoPessoa: TDtoPessoa;
  LIdPessoa: System.Integer;
begin
  LDtoPessoa := TDtoPessoa.Create();
  LDaoPessoa := TDaoPessoa.Create(FDConnection);
  LIdPessoa := Request.QueryFields.Values['idpessoa'].ToInteger;
  try
    if (LDaoPessoa.Load(LDtoPessoa, LIdPessoa)) then
    begin
      Response.StatusCode := 200;
      Response.Content := TJson.ObjectToJsonString(LDtoPessoa);
    end else
    begin
      Response.StatusCode := 404;
      Response.Content := '{"message": "Pessoa n�o encontrada com o Id informado."}';
    end;
  finally
    LDtoPessoa.Free;
    LDaoPessoa.Free;
  end;
end;

procedure TWebModule1.WebModule1PATCHPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDaoPessoa: TDaoPessoa;
  LDtoPessoa: TDtoPessoa;
begin
  LDtoPessoa := TDtoPessoa.Create();
  LDaoPessoa := TDaoPessoa.Create(FDConnection);
  try                                           
    LDtoPessoa.idpessoa := Request.ContentFields.Values['idpessoa'].ToInteger;
    LDtoPessoa.flnatureza := Request.ContentFields.Values['flnatureza'].ToInteger;
    LDtoPessoa.dsdocumento := Request.ContentFields.Values['dsdocumento'];
    LDtoPessoa.nmprimeiro := Request.ContentFields.Values['nmprimeiro'];
    LDtoPessoa.nmsegundo := Request.ContentFields.Values['nmsegundo'];
    LDtoPessoa.dscep := Request.ContentFields.Values['dscep'];
    try
      LDaoPessoa.Save(LDtoPessoa);
    except
      Response.StatusCode := 500;
      Response.Content := '{"message": "Erro ao atualizar registro."}';
      exit;
    end;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Registro atualizado com suscesso."}'
  finally
    LDtoPessoa.Free;
    LDaoPessoa.Free;
  end;
end;

procedure TWebModule1.WebModule1PessoasLoteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JSonValue: TJSONArray;
  JSonArray: TJSONArray;
  ArrayElement: TJSonValue;
  LDtoPessoa: TDtoPessoa;
  LDaoPessoa: TDaoPessoa;
begin
  LDtoPessoa := TDtoPessoa.Create;
  LDaoPessoa := TDaoPessoa.Create(FDConnection);

  JSonValue :=  TJSONObject.ParseJSONValue(Request.Content) as TJsonArray;
  try
    for ArrayElement in JsonArray do
    begin
      try
        LDtoPessoa.flnatureza := ArrayElement.FindValue('flnatureza').Value.ToInteger;
        LDtoPessoa.dsdocumento := ArrayElement.FindValue('dsdocumento').Value;
        LDtoPessoa.nmprimeiro := ArrayElement.FindValue('nmprimeiro').Value;
        LDtoPessoa.nmsegundo := ArrayElement.FindValue('nmsegundo').Value;
        LDtoPessoa.dscep := ArrayElement.FindValue('dscep').Value;
        LDtoPessoa.dtregistro := Now;
        LDaoPessoa.Save(LDtoPessoa);
      finally
        LDtoPessoa.Clear;
      end;
    end;
  finally
    LDaoPessoa.Free;
    LDtoPessoa.Free;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Lote cadastrado com suscesso."}'
  end;
end;

procedure TWebModule1.WebModule1POSTPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDaoPessoa: TDaoPessoa;
  LDtoPessoa: TDtoPessoa;
begin
  LDtoPessoa := TDtoPessoa.Create();
  LDaoPessoa := TDaoPessoa.Create(FDConnection);
  try
    LDtoPessoa.flnatureza := Request.ContentFields.Values['flnatureza'].ToInteger;
    LDtoPessoa.dsdocumento := Request.ContentFields.Values['dsdocumento'];
    LDtoPessoa.nmprimeiro := Request.ContentFields.Values['nmprimeiro'];
    LDtoPessoa.nmsegundo := Request.ContentFields.Values['nmsegundo'];
    LDtoPessoa.dscep := Request.ContentFields.Values['dscep'];
    LDtoPessoa.dtregistro := Now;
    try
      LDaoPessoa.Save(LDtoPessoa);
    except
      Response.StatusCode := 501;    
      Response.Content := '{"message": "Erro ao cadastrar pessoa."}';
      exit;
    end;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Pessoa cadastrada com suscesso."}'
  finally
    LDtoPessoa.Free;
    LDaoPessoa.Free;
  end;
end;

end.
