unit Pessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON,
  Form_Pesquisa, System.IOUtils;

type
  TFormCadastroPessoas = class(TForm)
    lblNome: TLabel;
    edNome: TEdit;
    edSobrenome: TEdit;
    lblSobrenome: TLabel;
    edDocumento: TEdit;
    lblDocumento: TLabel;
    edNatureza: TEdit;
    lblNatureza: TLabel;
    btnSalvar: TButton;
    btnExecIntegrador: TButton;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse1: TRESTResponse;
    edCep: TEdit;
    lblCep: TLabel;
    btnPesquisar: TButton;
    edIdPessoa: TEdit;
    lblIdPessoa: TLabel;
    btnExcluir: TButton;
    RESTRequestIntegrador: TRESTRequest;
    btnCarregarLote: TButton;
    RESTLote: TRESTRequest;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure GetPessoa(const AId: System.String);
    procedure btnExcluirClick(Sender: TObject);
    function ValidaCampos: System.Boolean;
    function RemoveAspasDuplas(const ATexto: System.String): System.String;
    procedure LimparCampos;
    procedure btnExecIntegradorClick(Sender: TObject);
    procedure btnCarregarLoteClick(Sender: TObject);
  private
    { Private declarations }
    FPath: System.String;
  public
    { Public declarations }
  end;

var
  FormCadastroPessoas: TFormCadastroPessoas;

implementation

{$R *.dfm}

procedure TFormCadastroPessoas.btnSalvarClick(Sender: TObject);
var
  JsonValue: TJSONValue;
  LObj: TJSONObject;
begin
  if ValidaCampos then
    Exit;

  RESTRequest.Params.AddItem('flnatureza', edNatureza.Text);
  RESTRequest.Params.AddItem('dsdocumento', edDocumento.Text);
  RESTRequest.Params.AddItem('nmprimeiro', edNome.Text);
  RESTRequest.Params.AddItem('nmsegundo', edSobrenome.Text);
  RESTRequest.Params.AddItem('dscep', edCep.Text);

  if(edIdPessoa.Text <> '') then
  begin
    RESTRequest.Params.AddItem('idpessoa', edIdPessoa.Text);
    RESTRequest.Method := TRESTRequestMethod.rmPATCH;
  end else
    RESTRequest.Method := TRESTRequestMethod.rmPOST;

  RESTRequest.Execute;
  RESTRequest.Params.Clear;

  LObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  ShowMessage(LObj.Values['message'].ToString);
  LimparCampos();
end;

procedure TFormCadastroPessoas.btnExecIntegradorClick(Sender: TObject);
var
  LObj: TJSONObject;
begin
  RESTRequestIntegrador.Method := TRESTRequestMethod.rmGET;
  RESTRequestIntegrador.ExecuteAsync(
    procedure
    begin
      LObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
      if (RESTResponse1.StatusCode = 200) then
      begin
        ShowMessage(LObj.Values['message'].ToString);
      end else
      if (RESTResponse1.StatusCode = 501) then
      begin
        ShowMessage(LObj.Values['message'].ToString);
      end;
    end
  );
end;

procedure TFormCadastroPessoas.btnCarregarLoteClick(Sender: TObject);
var
  FileName: TFileName;
  JSONValue: TJSONArray;
  dlg: TOpenDialog;
  LObj: TJSONObject;
begin
  dlg := TOpenDialog.Create(nil);

  try
    dlg.InitialDir := 'C:\';
    dlg.Filter := 'All files (*.*)|*.*';
    if dlg.Execute(Handle) then
      FileName := dlg.FileName;
  finally
    dlg.Free;
  end;

  if FileName <> '' then
  begin
    JSONValue := TJSONObject.ParseJSONValue(TFile.ReadAllText(FileName)) as TJsonArray;
    RESTClient.ContentType := 'application/json';
    RESTLote.Body.ClearBody;
    RESTLote.AddBody(JSONValue);
    RESTLote.ExecuteAsync(
      procedure
      begin
        LObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
        if (RESTResponse1.StatusCode = 200) then
        begin
          ShowMessage(LObj.Values['message'].ToString);
        end else
        if (RESTResponse1.StatusCode = 500) then
        begin
          ShowMessage('Erro ao registrar lote.'+LObj.Values['message'].ToString);
        end;
      end
    );
  end;
end;

procedure TFormCadastroPessoas.btnExcluirClick(Sender: TObject);
var
  LObj: TJSONObject;
begin
  if(edIdPessoa.Text = '') then
  begin
    ShowMessage('Pequise uma pessoa antes de excluir.');
    exit;
  end;
  if (MessageDlg('Deseja realmente excluir este registro?',mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes) then
  begin
    RESTRequest.Params.AddItem('idpessoa', edIdPessoa.Text);
    RESTRequest.Method := TRESTRequestMethod.rmDELETE;
    RESTRequest.ExecuteAsync(
      procedure
      begin
        LObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
        if (RESTResponse1.StatusCode = 200) then
        begin
          ShowMessage(LObj.Values['message'].ToString);
          LimparCampos();
        end else
        if (RESTResponse1.StatusCode = 501) then
        begin
          ShowMessage('Erro ao excluir o registro.'+LObj.Values['message'].ToString);
        end;
      end
    );
    RESTRequest.Params.Clear;
  end;
  LimparCampos;
end;

procedure TFormCadastroPessoas.btnPesquisarClick(Sender: TObject);
var
  LFormPesquisa: TFormPesquisa;
begin
  LFormPesquisa := TFormPesquisa.Create(Self);
  LFormPesquisa.ShowModal;
  GetPessoa(LFormPesquisa.edId.Text);
end;

procedure TFormCadastroPessoas.GetPessoa(const AId: System.String);
var
  JsonValue: TJSONValue;
  LObj: TJSONObject;
begin
  if(AId = '') then exit;

  RESTRequest.Params.AddItem('idpessoa', AId);
  RESTRequest.Method := TRESTRequestMethod.rmGET;
  RESTRequest.Execute;
  RESTRequest.Params.Clear;

  LObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  if (RESTResponse1.StatusCode = 404) then
  begin
    ShowMessage('Cadastro n�o encontrado');
  end else
  begin
    edIdPessoa.Text := RemoveAspasDuplas(LObj.Values['idpessoa'].ToString);
    edNome.Text := RemoveAspasDuplas(LObj.Values['nmprimeiro'].ToString);
    edSobrenome.Text := RemoveAspasDuplas(LObj.Values['nmsegundo'].ToString);
    edDocumento.Text := RemoveAspasDuplas(LObj.Values['dsdocumento'].ToString);
    edNatureza.Text := RemoveAspasDuplas(LObj.Values['flnatureza'].ToString);
    edCep.Text := RemoveAspasDuplas(LObj.Values['dscep'].ToString);
  end;
end;

procedure TFormCadastroPessoas.LimparCampos;
var
  Contador: System.Integer;
begin
  for Contador := 0 to ComponentCount - 1 do
  begin
    if Components[Contador].ClassType = TEdit then
      if (TEdit(Components[Contador]).Text <> '') then
      begin
        TEdit(Components[Contador]).Text := '';
      end;
  end;
end;

function TFormCadastroPessoas.RemoveAspasDuplas(const ATexto: System.String): System.String;
begin
  Result := StringReplace(ATexto , '"', '', [rfReplaceAll]);
end;

function TFormCadastroPessoas.ValidaCampos: System.Boolean;
var
  Contador: System.Integer;
begin
  Result := False;
  for Contador := 0 to ComponentCount - 1 do
  begin
    if Components[Contador].ClassType = TEdit then
      if ((TEdit(Components[Contador]).Text = '') and TEdit(Components[Contador]).Enabled) then
      begin
        Result := true;
        TEdit(Components[Contador]).TextHint := 'Campo Obrigat�rio*';
      end else
      begin
        TEdit(Components[Contador]).TextHint := '';
      end;
  end;
end;

end.
