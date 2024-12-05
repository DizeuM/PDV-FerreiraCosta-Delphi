object DataModule1: TDataModule1
  OnCreate = DataModuleCreate
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=PDV_Ferreira_Costa;Data Source=DIZEU'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 364
    Top = 110
  end
  object QueryGerarPedido: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 270
    Top = 440
  end
  object QueryPedido: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 62
    Top = 192
  end
  object DataPedido: TDataSource
    DataSet = QueryPedido
    Left = 188
    Top = 188
  end
  object QueryPedidoIt: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 62
    Top = 344
  end
  object DataPedidoIt: TDataSource
    DataSet = QueryPedidoIt
    Left = 196
    Top = 348
  end
  object QueryProdutosEstoque: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 534
    Top = 208
  end
  object DataProdutosEstoque: TDataSource
    DataSet = QueryProdutosEstoque
    Left = 700
    Top = 204
  end
  object QueryCriarProduto: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 462
    Top = 424
  end
  object QueryDetalhesProduto: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 622
    Top = 336
  end
  object QueryLogin: TADOQuery
    AutoCalcFields = False
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    Left = 350
    Top = 288
  end
end
