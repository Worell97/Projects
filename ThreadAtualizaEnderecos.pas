unit ThreadAtualizaEnderecos;

interface

uses
  Classes, IdHTTP, DTO_Endereco, DAO_Endereco, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, SysUtils, DTO_Endereco_Integracao, DAO_Endereco_Integracao,
  REST.Json, JsonObjectIntegracao;

type
  TCepIntegracao = class(TThread)
  FDConnection: TFDConnection;
  private
   { Private declarations }
  protected
   procedure Execute; override;
end;

implementation

procedure TCepIntegracao.Execute;
var
  lHTTP: TIdHTTP;
  Response: string;
  LDtoEnderecos: TDtoEnderecos;
  LDaoEndereco: TDaoEndereco;
  Endereco: TDtoEndereco;
  Cep: System.String;
  LDaoEnderecoIntegracao: TDaoEnderecoIntegracao;
  LDtoEnderecoIntegracao: TDtoEnderecoIntegracao;
  JsonObject: TDtoJsonIntegracaoObject;
begin
  ReturnValue := 0;
  NameThreadForDebugging('Consulta Enderešos');
  FDConnection := TFDConnection.Create(nil);
  FDConnection.DriverName := 'PG';
  FDConnection.Params.Database := 'WKTeste';
  FDConnection.Params.UserName := 'postgres';
  FDConnection.Params.Password := '123';
  LDtoEnderecos := TDtoEnderecos.Create;
  LDaoEndereco := TDaoEndereco.Create(FDConnection);
  LDtoEnderecoIntegracao := TDtoEnderecoIntegracao.Create();
  LDaoEnderecoIntegracao := TDaoEnderecoIntegracao.Create(FDConnection);
  lHTTP := TIdHTTP.Create;
  try
    LDaoEndereco.LoadAll(LDtoEnderecos);
    for Endereco in LDtoEnderecos do
    begin
      if (Endereco.dscep.isEmpty) then
        continue;

      Cep := StringReplace(Endereco.dscep, '-', '', [rfReplaceAll]);
      Response := lHTTP.Get('HTTP://viacep.com.br/ws/'+Cep+'/json/');
      JsonObject := TJson.JsonToObject<TDtoJsonIntegracaoObject>(Response);
      LDtoEnderecoIntegracao.idendereco := Endereco.idendereco;
      LDtoEnderecoIntegracao.nmcidade := JsonObject.localidade;
      LDtoEnderecoIntegracao.dsuf := JsonObject.uf;
      LDtoEnderecoIntegracao.nmbairro := JsonObject.bairro;
      LDtoEnderecoIntegracao.nmlogradouro := JsonObject.logradouro;
      LDtoEnderecoIntegracao.dscomplemento := JsonObject.complemento;
      LDaoEnderecoIntegracao.Save(LDtoEnderecoIntegracao);
      LDtoEnderecoIntegracao.Clear;
    end;
  finally
    lHTTP.Free;
    FDConnection.Free;
    LDtoEnderecos.Free;
    LDaoEndereco.Free;
    LDtoEnderecoIntegracao.Free;
    LDaoEnderecoIntegracao.Free;
  end;
end;

end.
