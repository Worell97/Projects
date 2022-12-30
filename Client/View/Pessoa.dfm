object FormCadastroPessoas: TFormCadastroPessoas
  Left = 0
  Top = 0
  Caption = 'Cadastro de pessoas'
  ClientHeight = 227
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    440
    227)
  PixelsPerInch = 96
  TextHeight = 13
  object lblNome: TLabel
    Left = 8
    Top = 47
    Width = 34
    Height = 13
    Caption = 'Nome: '
  end
  object lblSobrenome: TLabel
    Left = 8
    Top = 74
    Width = 58
    Height = 13
    Caption = 'Sobrenome:'
  end
  object lblDocumento: TLabel
    Left = 8
    Top = 101
    Width = 58
    Height = 13
    Caption = 'Documento:'
  end
  object lblNatureza: TLabel
    Left = 8
    Top = 128
    Width = 48
    Height = 13
    Caption = 'Natureza:'
  end
  object lblCep: TLabel
    Left = 8
    Top = 155
    Width = 19
    Height = 13
    Caption = 'Cep'
  end
  object lblIdPessoa: TLabel
    Left = 8
    Top = 20
    Width = 17
    Height = 13
    Caption = 'Id: '
  end
  object edNome: TEdit
    Left = 73
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edSobrenome: TEdit
    Left = 73
    Top = 71
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edDocumento: TEdit
    Left = 73
    Top = 98
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edNatureza: TEdit
    Left = 73
    Top = 125
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object btnSalvar: TButton
    Left = 315
    Top = 15
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = btnSalvarClick
    ExplicitLeft = 279
  end
  object btnExecIntegrador: TButton
    Left = 315
    Top = 123
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Executar integrador'
    TabOrder = 6
    OnClick = btnExecIntegradorClick
    ExplicitLeft = 279
  end
  object edCep: TEdit
    Left = 73
    Top = 152
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object btnPesquisar: TButton
    Left = 315
    Top = 42
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Pesquisar'
    TabOrder = 7
    OnClick = btnPesquisarClick
    ExplicitLeft = 279
  end
  object edIdPessoa: TEdit
    Left = 73
    Top = 17
    Width = 121
    Height = 21
    Color = clBtnFace
    Enabled = False
    NumbersOnly = True
    TabOrder = 8
  end
  object btnExcluir: TButton
    Left = 315
    Top = 69
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Excluir'
    TabOrder = 9
    OnClick = btnExcluirClick
    ExplicitLeft = 279
  end
  object btnCarregarLote: TButton
    Left = 315
    Top = 150
    Width = 113
    Height = 25
    Caption = 'Carregar Lote'
    TabOrder = 10
    OnClick = btnCarregarLoteClick
  end
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8000'
    Params = <>
    Left = 32
    Top = 176
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Resource = 'pessoa'
    Response = RESTResponse1
    Left = 96
    Top = 176
  end
  object RESTResponse1: TRESTResponse
    Left = 304
    Top = 176
  end
  object RESTRequestIntegrador: TRESTRequest
    AssignedValues = [rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'endereco_integracao'
    Response = RESTResponse1
    ReadTimeout = 3000000
    Left = 232
    Top = 176
  end
  object RESTLote: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'pessoas'
    Response = RESTResponse1
    Left = 144
    Top = 176
  end
end
