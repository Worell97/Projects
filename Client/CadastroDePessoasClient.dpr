program CadastroDePessoasClient;

uses
  Vcl.Forms,
  Pessoa in 'View\Pessoa.pas' {FormCadastroPessoas},
  Form_Pesquisa in 'View\Form_Pesquisa.pas' {FormPesquisa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormCadastroPessoas, FormCadastroPessoas);
  Application.CreateForm(TFormPesquisa, FormPesquisa);
  Application.CreateForm(TFormPesquisa, FormPesquisa);
  Application.Run;
end.
