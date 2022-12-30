object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtPost
      Name = 'POSTPessoa'
      PathInfo = '/pessoa'
      OnAction = WebModule1POSTPessoaAction
    end
    item
      MethodType = mtGet
      Name = 'GETPessoa'
      PathInfo = '/pessoa'
      OnAction = WebModule1GETPessoaAction
    end
    item
      MethodType = mtDelete
      Name = 'DELETEPessoa'
      PathInfo = '/pessoa'
      OnAction = WebModule1DELETEPessoaAction
    end
    item
      MethodType = mtPatch
      Name = 'PATCHPessoa'
      PathInfo = '/pessoa'
      OnAction = WebModule1PATCHPessoaAction
    end
    item
      MethodType = mtGet
      Name = 'ExecutaIntegrador'
      PathInfo = '/endereco_integracao'
      OnAction = WebModule1ExecutaIntegradorAction
    end
    item
      MethodType = mtPost
      Name = 'PessoasLote'
      PathInfo = '/pessoas'
      OnAction = WebModule1PessoasLoteAction
    end>
  Height = 230
  Width = 415
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=PG'
      'Database=WKTeste'
      'User_Name=postgres'
      'Server=localhost'
      'Password=123')
    Left = 56
    Top = 160
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 128
    Top = 152
  end
end
