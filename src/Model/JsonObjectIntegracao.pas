unit JsonObjectIntegracao;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, SysUtils;
type
  TDtoJsonIntegracaoObject = class;
  TDtoJsonIntegracaoObject = class(TObject)
  private
    FLogradouro: System.String;
    FIbge: System.String;
    FBairro: System.String;
    FDdd: System.String;
    FUf: System.String;
    FCep: System.String;
    FSiafi: System.String;
    FLocalidade: System.String;
    FGia: System.String;
    FComplemento: System.String;
    { private declarations }
    procedure InternalClear();
    procedure SetBairro(const Value: System.String);
    procedure SetCep(const Value: System.String);
    procedure SetComplemento(const Value: System.String);
    procedure SetDdd(const Value: System.String);
    procedure SetGia(const Value: System.String);
    procedure SetIbge(const Value: System.String);
    procedure SetLocalidade(const Value: System.String);
    procedure SetLogradouro(const Value: System.String);
    procedure SetSiafi(const Value: System.String);
    procedure SetUf(const Value: System.String);
  public
    constructor Create();
    procedure Clear; inline;
    property cep: System.String read FCep write SetCep;
    property logradouro: System.String read FLogradouro write SetLogradouro;
    property complemento: System.String read FComplemento write SetComplemento;
    property bairro: System.String read FBairro write SetBairro;
    property localidade: System.String  read FLocalidade write SetLocalidade;
    property uf: System.String  read FUf write SetUf;
    property ibge: System.String  read FIbge write SetIbge;
    property gia: System.String  read FGia write SetGia;
    property ddd: System.String  read FDdd write SetDdd;
    property siafi: System.String  read FSiafi write SetSiafi;
  end;
implementation
{ TDtoJsonIntegracaoObject }

procedure TDtoJsonIntegracaoObject.Clear;
begin
  Self.InternalClear();
end;

constructor TDtoJsonIntegracaoObject.Create();
begin
  Self.InternalClear();
end;


procedure TDtoJsonIntegracaoObject.InternalClear;
begin
  FLogradouro := '';
  FIbge := '';
  FBairro := '';
  FDdd := '';
  FUf := '';
  FCep := '';
  FSiafi := '';
  FLocalidade := '';
  FComplemento := '';
  FGia := '';
end;

procedure TDtoJsonIntegracaoObject.SetBairro(const Value: System.String);
begin
  FBairro := Value;
end;

procedure TDtoJsonIntegracaoObject.SetCep(const Value: System.String);
begin
  FCep := Value;
end;

procedure TDtoJsonIntegracaoObject.SetComplemento(const Value: System.String);
begin
  FComplemento := Value;
end;

procedure TDtoJsonIntegracaoObject.SetDdd(const Value: System.String);
begin
  FDdd := Value;
end;

procedure TDtoJsonIntegracaoObject.SetGia(const Value: System.String);
begin
  FGia := Value;
end;

procedure TDtoJsonIntegracaoObject.SetIbge(const Value: System.String);
begin
  FIbge := Value;
end;

procedure TDtoJsonIntegracaoObject.SetLocalidade(const Value: System.String);
begin
  FLocalidade := Value;
end;

procedure TDtoJsonIntegracaoObject.SetLogradouro(const Value: System.String);
begin
  FLogradouro := Value;
end;

procedure TDtoJsonIntegracaoObject.SetSiafi(const Value: System.String);
begin
  FSiafi := Value;
end;

procedure TDtoJsonIntegracaoObject.SetUf(const Value: System.String);
begin
  FUf := Value;
end;

end.
