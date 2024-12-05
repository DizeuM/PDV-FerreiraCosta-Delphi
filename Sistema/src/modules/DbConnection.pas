unit DbConnection;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    ADOConnection1: TADOConnection;  // ADOConnection1 deve ser declarado aqui
    QueryGerarPedido: TADOQuery;
    QueryPedido: TADOQuery;
    DataPedido: TDataSource;
    QueryPedidoIt: TADOQuery;
    DataPedidoIt: TDataSource;
    QueryProdutosEstoque: TADOQuery;
    DataProdutosEstoque: TDataSource;
    QueryCriarProduto: TADOQuery;
    QueryDetalhesProduto: TADOQuery;
    QueryLogin: TADOQuery;

    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  try
    if not ADOConnection1.Connected then
      ADOConnection1.Open;
  except
    on E: Exception do
    begin
      raise Exception.CreateFmt('Erro ao conectar ao banco de dados: %s', [E.Message]);
    end;
  end;
end;

end.

