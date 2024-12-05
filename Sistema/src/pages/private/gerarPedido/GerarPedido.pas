unit GerarPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Datasnap.DBClient, Vcl.Buttons,
  Vcl.Imaging.pngimage;

type
  TFrameGerarPedido = class(TFrame)
    InputProdId: TEdit;
    InputProdNome: TEdit;
    InputProdQnt: TEdit;
    InputProdPrecoUn: TEdit;
    InputProdPrecoTotal: TEdit;
    BtnLancarItem: TSpeedButton;
    BtnGerarPedido: TSpeedButton;
    gridPedido: TDBGrid;
    CDSItens: TClientDataSet;
    DataSource1: TDataSource;
    ImageFundo: TImage;
    inputProdFornecedor: TEdit;
    LabelTotalPedido: TLabel;

    procedure ConfigurarGridProdutos(Sender: TObject);
    procedure BtnLancarItemClick(Sender: TObject);
    procedure BtnExcluirItemClick(Column: TColumn);
    procedure BtnGerarPedidoClick(Sender: TObject);
    procedure PesquisarProdOnChange(Sender: TObject);
    procedure ProdQntChange(Sender: TObject);
  private
    procedure BuscarNomeProduto(const Codigo: string);
    procedure CalcularPrecoTotal;
    procedure AdicionarItem;
    procedure AtualizarTotalPedido;
  public
  end;

var
  FrameGerarPedido: TFrameGerarPedido;

implementation

{$R *.dfm}

uses DbConnection, System.IniFiles;

procedure TFrameGerarPedido.ConfigurarGridProdutos(Sender: TObject);
begin
  if not CDSItens.Active then
  begin
    CDSItens.FieldDefs.Add('ID Produto', ftInteger);
    CDSItens.FieldDefs.Add('Descrição', ftString, 40);
    CDSItens.FieldDefs.Add('Quantidade', ftFloat);
    CDSItens.FieldDefs.Add('Valor UN', ftFloat);
    CDSItens.FieldDefs.Add('Valor Total', ftFloat);
    CDSItens.FieldDefs.Add('Fornecedor', ftString, 14);
    CDSItens.CreateDataSet;

    DataSource1.DataSet := CDSItens;

    gridPedido.Columns[0].Width := 80;
    gridPedido.Columns[1].Width := 230;
    gridPedido.Columns[2].Width := 85;
    gridPedido.Columns[3].Width := 70;
    gridPedido.Columns[4].Width := 80;
    gridPedido.Columns[5].Width := 130;
  end;
end;

procedure TFrameGerarPedido.BtnLancarItemClick(Sender: TObject);
begin
  AdicionarItem;
end;

procedure TFrameGerarPedido.BtnExcluirItemClick(Column: TColumn);
begin
  if CDSItens.IsEmpty then
  begin
    ShowMessage('Não há itens para excluir.');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja excluir o item selecionado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    CDSItens.Delete;
    AtualizarTotalPedido;
  end;
end;

procedure TFrameGerarPedido.PesquisarProdOnChange(Sender: TObject);
begin
  if Trim(InputProdId.Text) = '' then
  begin
    InputProdNome.Text := '';
    InputProdQnt.Text := '';
    InputProdPrecoUn.Text := '';
    InputProdPrecoTotal.Text := '';
    inputProdFornecedor.Text := '';
  end
  else
  begin
    BuscarNomeProduto(InputProdId.Text);
  end;
end;

procedure TFrameGerarPedido.BuscarNomeProduto(const Codigo: string);
var
  descricao: string;
  valorUn: Double;
  fornecedor: string;
begin
  DataModule1.QueryGerarPedido.Close;
  DataModule1.QueryGerarPedido.SQL.Text := 'SELECT Descricao, valor_un, fornecedor FROM PRODUTO_ESTOQUE WHERE id = :IdProd';
  DataModule1.QueryGerarPedido.Parameters.ParamByName('IdProd').Value := StrToInt(Codigo);
  DataModule1.QueryGerarPedido.Open;

  if not DataModule1.QueryGerarPedido.IsEmpty then
  begin
    descricao := DataModule1.QueryGerarPedido.FieldByName('descricao').AsString;
    valorUn := DataModule1.QueryGerarPedido.FieldByName('valor_un').AsFloat;
    fornecedor := DataModule1.QueryGerarPedido.FieldByName('fornecedor').AsString;

    InputProdNome.Text := descricao;
    InputProdPrecoUn.Text := FormatFloat('0.00', valorUn);
    inputProdFornecedor.Text := fornecedor;
    InputProdQnt.Text := '1';
  end
  else
  begin
    InputProdNome.Text := '';
    InputProdPrecoUn.Text := '';
    inputProdFornecedor.Text := '';
    InputProdQnt.Text := '';
  end;
end;

procedure TFrameGerarPedido.ProdQntChange(Sender: TObject);
begin
  CalcularPrecoTotal;
end;

procedure TFrameGerarPedido.CalcularPrecoTotal;
var
  quantidade, precoUnitario: Double;
begin
  if TryStrToFloat(InputProdQnt.Text, quantidade) and TryStrToFloat(InputProdPrecoUn.Text, precoUnitario) then
    InputProdPrecoTotal.Text := FormatFloat('0.00', quantidade * precoUnitario)
  else
    InputProdPrecoTotal.Text := '';
end;

procedure TFrameGerarPedido.AdicionarItem;
var
  idProduto: Integer;
  quantidade, valorUn, valorTotal: Double;
begin
  if TryStrToInt(InputProdId.Text, idProduto) and
     TryStrToFloat(InputProdQnt.Text, quantidade) and
     (quantidade > 0) and
     TryStrToFloat(InputProdPrecoUn.Text, valorUn) then
  begin
    valorTotal := quantidade * valorUn;

    CDSItens.Append;
    CDSItens.FieldByName('ID Produto').AsInteger := idProduto;
    CDSItens.FieldByName('Descrição').AsString := InputProdNome.Text;
    CDSItens.FieldByName('Quantidade').AsFloat := quantidade;
    CDSItens.FieldByName('Valor UN').AsFloat := valorUn;
    CDSItens.FieldByName('Valor Total').AsFloat := valorTotal;
    CDSItens.FieldByName('Fornecedor').AsString := inputProdFornecedor.Text;
    CDSItens.Post;

    AtualizarTotalPedido;
  end
  else
    ShowMessage('Preencha todos os campos corretamente.');
end;

procedure TFrameGerarPedido.AtualizarTotalPedido;
var
  Total: Double;
begin
  Total := 0;
  CDSItens.DisableControls;
  try
    CDSItens.First;
    while not CDSItens.Eof do
    begin
      Total := Total + CDSItens.FieldByName('Valor Total').AsFloat;
      CDSItens.Next;
    end;
  finally
    CDSItens.EnableControls;
  end;

  LabelTotalPedido.Caption := 'Total do Pedido: R$ ' + FormatFloat('0.00', Total);
end;

procedure TFrameGerarPedido.BtnGerarPedidoClick(Sender: TObject);
var
  nota, UltimaNota: String;
  totalPedido: Double;
  UltimoId, IdVendedor: Integer;

  function ObterIDDoINI: Integer;
  var
    IniFile: TIniFile;
    AppPath: string;
  begin
    AppPath := ExtractFilePath(Application.ExeName);
    IniFile := TIniFile.Create(AppPath + 'Config.ini');
    try
      Result := IniFile.ReadInteger('Login', 'VendedorID', -1);
    finally
      IniFile.Free;
    end;
  end;

begin
  if CDSItens.IsEmpty then
  begin
    ShowMessage('Não há itens para confirmar.');
    Exit;
  end;

  IdVendedor := ObterIDDoINI;

  try
    DataModule1.QueryGerarPedido.SQL.Text := 'SELECT TOP 1 id, nota FROM PEDIDO_VENDA ORDER BY id DESC';
    DataModule1.QueryGerarPedido.Open;
    UltimoId := DataModule1.QueryGerarPedido.FieldByName('id').AsInteger;
    UltimaNota := DataModule1.QueryGerarPedido.FieldByName('nota').AsString;

    DataModule1.QueryGerarPedido.Close;
    DataModule1.QueryGerarPedido.SQL.Text :=
      'INSERT INTO PEDIDO_VENDA (tipo, nota, data_movim, valor_total_venda, id_vendedor) ' +
      'VALUES (:tipo, :nota, :data_movim, :valor_total_venda, :id_vendedor)';
    nota := IntToStr(StrToInt(UltimaNota) + 1);

    totalPedido := 0;
    CDSItens.First;
    while not CDSItens.Eof do
    begin
      totalPedido := totalPedido + CDSItens.FieldByName('Valor Total').AsFloat;
      CDSItens.Next;
    end;

    DataModule1.QueryGerarPedido.Parameters.ParamByName('nota').Value := nota;
    DataModule1.QueryGerarPedido.Parameters.ParamByName('tipo').Value := 'VD';
    DataModule1.QueryGerarPedido.Parameters.ParamByName('data_movim').Value := Now;
    DataModule1.QueryGerarPedido.Parameters.ParamByName('valor_total_venda').Value := totalPedido;
    DataModule1.QueryGerarPedido.Parameters.ParamByName('id_vendedor').Value := IdVendedor;
    DataModule1.QueryGerarPedido.ExecSQL;

    CDSItens.First;
    while not CDSItens.Eof do
    begin
      DataModule1.QueryGerarPedido.Close;
      DataModule1.QueryGerarPedido.SQL.Text :=
        'INSERT INTO PEDIDO_VENDA_IT (id_pedido_venda, id_prod, fornecedor, qnt, valor_un, valor_total) ' +
        'VALUES (:id_pedido_venda, :id_prod, :fornecedor, :qnt, :valor_un, :valor_total)';

      DataModule1.QueryGerarPedido.Parameters.ParamByName('id_pedido_venda').Value := UltimoId + 1;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('id_prod').Value := CDSItens.FieldByName('ID Produto').AsInteger;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('fornecedor').Value := CDSItens.FieldByName('Fornecedor').AsString;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('qnt').Value := CDSItens.FieldByName('Quantidade').AsInteger;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('valor_un').Value := CDSItens.FieldByName('Valor UN').AsFloat;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('valor_total').Value := CDSItens.FieldByName('Valor Total').AsFloat;
      DataModule1.QueryGerarPedido.ExecSQL;

      DataModule1.QueryGerarPedido.Close;
      DataModule1.QueryGerarPedido.SQL.Text :=
        'UPDATE PRODUTO_ESTOQUE ' +
        'SET qnt_estoque = qnt_estoque - :qnt ' +
        'WHERE id = :id';

      DataModule1.QueryGerarPedido.Parameters.ParamByName('qnt').Value := CDSItens.FieldByName('Quantidade').AsFloat;
      DataModule1.QueryGerarPedido.Parameters.ParamByName('id').Value := CDSItens.FieldByName('ID Produto').AsInteger;
      DataModule1.QueryGerarPedido.ExecSQL;

      CDSItens.Next;
    end;

    ShowMessage('Pedido gerado com sucesso. Nota: ' + nota);

    CDSItens.EmptyDataSet;
    gridPedido.Refresh;

    InputProdId.Text := '';
    LabelTotalPedido.Caption := 'Total do Pedido:';
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao gerar pedido: ' + E.Message);
    end;
  end;
end;

end.

