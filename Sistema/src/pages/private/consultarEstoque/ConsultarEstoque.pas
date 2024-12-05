unit ConsultarEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Menus;

type
  TFrameConsultarEstoque = class(TFrame)
    ImageFundo: TImage;
    InputProdId: TEdit;
    InputProdNome: TEdit;
    gridProdutos: TDBGrid;
    BtnCriarProduto: TSpeedButton;
    InputProdCategoria: TComboBox;
    inputProdFornecedor: TComboBox;

    procedure PesquisarProdutos(Sender: TObject);
    procedure BtnCriarProdutoClick(Sender: TObject);
    procedure gridProdutosDblClick(Column: TColumn);
  private
    procedure BuscarProdutos;
    procedure ConfigurarGridProdutos;
    procedure PreencherParametros(const SQLBase: string);
  public
  end;

implementation

{$R *.dfm}

uses DbConnection, Utils, CriarProduto, DetalhesProduto;

procedure TFrameConsultarEstoque.PesquisarProdutos(Sender: TObject);
begin
  CarregarCategorias(InputProdCategoria);
  CarregarFornecedores(InputProdFornecedor);
  BuscarProdutos;
end;

procedure TFrameConsultarEstoque.BuscarProdutos;
var
  SQLBase: string;
begin
  SQLBase := 'SELECT id, descricao, valor_un, qnt_estoque, categoria, fornecedor FROM PRODUTO_ESTOQUE WHERE qnt_estoque > 0';

  if Trim(InputProdId.Text) <> '' then
    SQLBase := SQLBase + ' AND id = :id';

  if Trim(InputProdNome.Text) <> '' then
    SQLBase := SQLBase + ' AND descricao LIKE :descricao';

  if Trim(InputProdCategoria.Text) <> '' then
    SQLBase := SQLBase + ' AND categoria LIKE :categoria';

  if Trim(InputProdFornecedor.Text) <> '' then
    SQLBase := SQLBase + ' AND fornecedor LIKE :fornecedor';

  DataModule1.QueryProdutosEstoque.Close;
  DataModule1.QueryProdutosEstoque.SQL.Text := SQLBase;

  PreencherParametros(SQLBase);
  DataModule1.QueryProdutosEstoque.Open;

  ConfigurarGridProdutos;

  try
  except
    on E: Exception do
      ShowMessage('Erro ao buscar os produtos: ' + E.Message);
  end;
end;

procedure TFrameConsultarEstoque.PreencherParametros(const SQLBase: string);
begin
  if Trim(InputProdId.Text) <> '' then
    DataModule1.QueryProdutosEstoque.Parameters.ParamByName('id').Value := StrToInt(InputProdId.Text);

  if Trim(InputProdNome.Text) <> '' then
    DataModule1.QueryProdutosEstoque.Parameters.ParamByName('descricao').Value := '%' + InputProdNome.Text + '%';

  if Trim(InputProdCategoria.Text) <> '' then
    DataModule1.QueryProdutosEstoque.Parameters.ParamByName('categoria').Value := '%' + InputProdCategoria.Text + '%';

  if Trim(InputProdFornecedor.Text) <> '' then
    DataModule1.QueryProdutosEstoque.Parameters.ParamByName('fornecedor').Value := '%' + InputProdFornecedor.Text + '%';
end;

procedure TFrameConsultarEstoque.ConfigurarGridProdutos;
begin
  gridProdutos.Columns[0].Title.Caption := 'ID Produto';
  gridProdutos.Columns[1].Title.Caption := 'Descrição';
  gridProdutos.Columns[2].Title.Caption := 'Valor UN';
  gridProdutos.Columns[3].Title.Caption := 'Quantidade';
  gridProdutos.Columns[4].Title.Caption := 'Categoria';
  gridProdutos.Columns[5].Title.Caption := 'Fornecedor';

  gridProdutos.Columns[0].Width := 80;
  gridProdutos.Columns[1].Width := 230;
  gridProdutos.Columns[2].Width := 70;
  gridProdutos.Columns[3].Width := 85;
  gridProdutos.Columns[4].Width := 120;
  gridProdutos.Columns[5].Width := 130;
end;

procedure TFrameConsultarEstoque.BtnCriarProdutoClick(Sender: TObject);
var
  FormCriarProduto: TFormCriarProduto;
begin
  FormCriarProduto := TFormCriarProduto.Create(nil);
  try
    FormCriarProduto.ShowModal;
  finally
    FormCriarProduto.Free;
  end;
end;

procedure TFrameConsultarEstoque.gridProdutosDblClick(Column: TColumn);
var
  FormDetalhesProduto: TFormDetalhesProduto;
begin
  if not DataModule1.QueryProdutosEstoque.IsEmpty then
  begin
    FormDetalhesProduto := TFormDetalhesProduto.Create(nil);
    try
      FormDetalhesProduto.InputProdId.Text := DataModule1.QueryProdutosEstoque.FieldByName('id').AsString;
      FormDetalhesProduto.InputProdNome.Text := DataModule1.QueryProdutosEstoque.FieldByName('descricao').AsString;
      FormDetalhesProduto.InputProdCategoria.Text := DataModule1.QueryProdutosEstoque.FieldByName('categoria').AsString;
      FormDetalhesProduto.InputProdFornecedor.Text := DataModule1.QueryProdutosEstoque.FieldByName('fornecedor').AsString;
      FormDetalhesProduto.InputProdPrecoUn.Text := DataModule1.QueryProdutosEstoque.FieldByName('valor_un').AsString;
      FormDetalhesProduto.InputProdQnt.Text := DataModule1.QueryProdutosEstoque.FieldByName('qnt_estoque').AsString;

      FormDetalhesProduto.ShowModal;
    finally
      FormDetalhesProduto.Free;
    end;
  end;
end;

end.

