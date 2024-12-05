unit HistoricoPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TFrameHistoricoPedidos = class(TFrame)
    gridProdutos: TDBGrid;
    gridPedidos: TDBGrid;
    InputDataInicio: TDateTimePicker;
    InputDataFim: TDateTimePicker;
    LabelProdutoPedido: TLabel;
    InputPedido: TEdit;
    InputNota: TEdit;
    inputVendedor: TEdit;
    LabelTotalPedido: TLabel;
    ImageFundo: TImage;

    procedure PesquisarPedidos(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);

  private
    procedure BuscarPedidos;
    procedure BuscarDetalhesPedido(const idPedido: string);
    procedure ConfigurarGridPedidos;
    procedure ConfigurarGridPedidosIt;
  public

  end;

implementation

{$R *.dfm}

uses
  DbConnection;

procedure TFrameHistoricoPedidos.PesquisarPedidos(Sender: TObject);
begin
  BuscarPedidos;
end;

procedure TFrameHistoricoPedidos.BuscarPedidos;
var
  SQLBase: string;
  PedidoValue, VendedorValue: Integer;
begin
  try
    SQLBase := 'SELECT id, nota, tipo, data_movim, valor_total_venda, id_vendedor FROM PEDIDO_VENDA WHERE data_movim BETWEEN :DataInicio AND :DataFim';

    if InputNota.Text <> '' then
      SQLBase := SQLBase + ' AND nota LIKE :nota';

    if InputPedido.Text <> '' then
      SQLBase := SQLBase + ' AND id = :idPedido';

    if inputVendedor.Text <> '' then
      SQLBase := SQLBase + ' AND id_vendedor = :idVendedor';

    DataModule1.QueryPedido.Close;
    DataModule1.QueryPedido.SQL.Text := SQLBase;

    DataModule1.QueryPedido.Parameters.ParamByName('DataInicio').Value := InputDataInicio.DateTime;
    DataModule1.QueryPedido.Parameters.ParamByName('DataFim').Value := InputDataFim.DateTime;

    if InputNota.Text <> '' then
      DataModule1.QueryPedido.Parameters.ParamByName('nota').Value := '%' + InputNota.Text + '%';

    if InputPedido.Text <> '' then
      if TryStrToInt(InputPedido.Text, PedidoValue) then
        DataModule1.QueryPedido.Parameters.ParamByName('idPedido').Value := PedidoValue
      else
        raise Exception.Create('O valor inserido no campo Pedido não é um número válido.');

    if inputVendedor.Text <> '' then
      if TryStrToInt(inputVendedor.Text, VendedorValue) then
        DataModule1.QueryPedido.Parameters.ParamByName('idVendedor').Value := VendedorValue
      else
        raise Exception.Create('O valor inserido no campo Vendedor não é um número válido.');

    DataModule1.QueryPedido.Open;

    ConfigurarGridPedidos

  except
    on E: Exception do
      ShowMessage('Erro ao buscar os pedidos: ' + E.Message);
  end;
end;

procedure TFrameHistoricoPedidos.DBGrid1CellClick(Column: TColumn);
var
  idPedido: string;
  valorTotal: Currency;
begin
  if not DataModule1.DataPedido.DataSet.Active then
  begin
    ShowMessage('A tabela de pedidos não está carregada.');
    Exit;
  end;

  try
    idPedido := DataModule1.DataPedido.DataSet.FieldByName('id').AsString;
    LabelProdutoPedido.Caption := Format('Produtos - Pedido %s', [idPedido]);
    valorTotal := DataModule1.DataPedido.DataSet.FieldByName('valor_total_venda').AsCurrency;
    LabelTotalPedido.Caption := Format('Total Pedido: R$ %.2f', [valorTotal]);
    BuscarDetalhesPedido(idPedido);

  except
    on E: Exception do
      ShowMessage('Erro ao buscar os detalhes do pedido: ' + E.Message);
  end;
end;

procedure TFrameHistoricoPedidos.BuscarDetalhesPedido(const idPedido: string);
begin
  try
   DataModule1.QueryPedidoIt.Close;
  DataModule1.QueryPedidoIt.SQL.Text :=
      'SELECT pvi.id_prod, pe.descricao, pvi.qnt, pvi.valor_un, pvi.valor_total, pvi.fornecedor ' +
      'FROM PEDIDO_VENDA_IT pvi ' +
      'INNER JOIN PRODUTO_ESTOQUE pe ON pvi.id_prod = pe.id ' +
      'WHERE pvi.id_pedido_venda = :idPedido';
  DataModule1.QueryPedidoIt.Parameters.ParamByName('idPedido').Value := idPedido;
  DataModule1.QueryPedidoIt.Open;

    ConfigurarGridPedidosIt;

  except
    on E: Exception do
      ShowMessage('Erro ao buscar os detalhes do pedido: ' + E.Message);
  end;
end;

procedure TFrameHistoricoPedidos.ConfigurarGridPedidos;
begin
  gridPedidos.Columns[0].Title.Caption := 'N° Pedido';
  gridPedidos.Columns[1].Title.Caption := 'N° Nota';
  gridPedidos.Columns[2].Title.Caption := 'Tipo';
  gridPedidos.Columns[3].Title.Caption := 'Data';
  gridPedidos.Columns[4].Title.Caption := 'Valor Total';
  gridPedidos.Columns[5].Title.Caption := 'ID Vendedor';

  gridPedidos.Columns[0].Width := 100;
  gridPedidos.Columns[1].Width := 100;
  gridPedidos.Columns[2].Width := 50;
  gridPedidos.Columns[3].Width := 150;
  gridPedidos.Columns[4].Width := 100;
  gridPedidos.Columns[5].Width := 100;
end;

procedure TFrameHistoricoPedidos.ConfigurarGridPedidosIt;
begin
  gridProdutos.Columns[0].Title.Caption := 'ID Produto';
  gridProdutos.Columns[1].Title.Caption := 'Descrição';
  gridProdutos.Columns[2].Title.Caption := 'Quantidade';
  gridProdutos.Columns[3].Title.Caption := 'Valor Total';
  gridProdutos.Columns[4].Title.Caption := 'Valor UN';
  gridProdutos.Columns[5].Title.Caption := 'Fornecedor';

  gridProdutos.Columns[0].Width := 80;
  gridProdutos.Columns[1].Width := 230;
  gridProdutos.Columns[2].Width := 85;
  gridProdutos.Columns[3].Width := 80;
  gridProdutos.Columns[4].Width := 70;
  gridProdutos.Columns[5].Width := 130;
end;

end.

