unit Form_Pesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormPesquisa = class(TForm)
    lblId: TLabel;
    edId: TEdit;
    btnConfirmar: TButton;
    procedure btnConfirmarClick(Sender: TObject);
  private
    { Private declarations }
    FIdPessoa: System.String;
    function GetIdPessoa: System.String;
    procedure SetIdPessoa(const Value: System.String);
  public
    { Public declarations }
    property IdPessoa: System.String read GetIdPessoa write SetIdPessoa;

  end;

var
  FormPesquisa: TFormPesquisa;

implementation

{$R *.dfm}

procedure TFormPesquisa.btnConfirmarClick(Sender: TObject);
begin
  if (edId.Text = '') then
  begin
    ShowMessage('Informe um id para pesquisar.');
    exit;
  end;

  SetIdPessoa(edId.Text);
  Self.Close;
end;

function TFormPesquisa.GetIdPessoa: System.String;
begin
  result := FIdPessoa;
end;

procedure TFormPesquisa.SetIdPessoa(const Value: System.String);
begin
  FIdPessoa := Value;
end;

end.
