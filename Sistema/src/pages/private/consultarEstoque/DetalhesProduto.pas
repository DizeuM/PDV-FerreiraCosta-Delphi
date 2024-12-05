unit DetalhesProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB;

type
  TFormDetalhesProduto = class(TForm)
    InputProdId: TEdit;
    InputProdNome: TEdit;
    InputProdPrecoUn: TEdit;
    InputProdQnt: TEdit;
    ImageFundo: TImage;
    InputProdCategoria: TComboBox;
    InputProdFornecedor: TComboBox;
    BtnSalvar: TSpeedButton;

    procedure BtnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AtualizarProduto;
    procedure ValidarCampos;
  public
  end;

var
  FormDetalhesProduto: TFormDetalhesProduto;

implementation

{$R *.dfm}

uses
  DbConnection, Utils;

procedure TFormDetalhesProduto.FormShow(Sender: TObject);
begin
  CarregarCategorias(InputProdCategoria);
  CarregarFornecedores(InputProdFornecedor);

  if InputProdCategoria.Items.IndexOf(InputProdCategoria.Text) >= 0 then
    InputProdCategoria.ItemIndex := InputProdCategoria.Items.IndexOf(InputProdCategoria.Text);

  if InputProdFornecedor.Items.IndexOf(InputProdFornecedor.Text) >= 0 then
    InputProdFornecedor.ItemIndex := InputProdFornecedor.Items.IndexOf(InputProdFornecedor.Text);
end;

procedure TFormDetalhesProduto.ValidarCampos;
begin
  if Trim(InputProdCategoria.Text) = '' then
    raise Exception.Create('A categoria do produto é obrigatória.');
  if Trim(InputProdFornecedor.Text) = '' then
    raise Exception.Create('O fornecedor do produto é obrigatório.');
  if Trim(InputProdPrecoUn.Text) = '' then
    raise Exception.Create('O preço unitário é obrigatório.');
  if Trim(InputProdQnt.Text) = '' then
    raise Exception.Create('A quantidade é obrigatória.');
end;

procedure TFormDetalhesProduto.AtualizarProduto;
begin
  with DataModule1.QueryDetalhesProduto do
  begin
    Close;
    SQL.Text := 'UPDATE PRODUTO_ESTOQUE SET descricao = :descricao, categoria = :categoria, fornecedor = :fornecedor, valor_un = :valor_un, qnt_estoque = :qnt_estoque WHERE id = :id';

    Parameters.ParamByName('id').Value := StrToInt(InputProdId.Text);
    Parameters.ParamByName('descricao').Value := Trim(InputProdNome.Text);
    Parameters.ParamByName('categoria').Value := Trim(InputProdCategoria.Text);
    Parameters.ParamByName('fornecedor').Value := Trim(InputProdFornecedor.Text);
    Parameters.ParamByName('valor_un').Value := StrToFloat(InputProdPrecoUn.Text);
    Parameters.ParamByName('qnt_estoque').Value := StrToInt(InputProdQnt.Text);

    ExecSQL;
  end;
end;

procedure TFormDetalhesProduto.BtnSalvarClick(Sender: TObject);
begin
  try
    ValidarCampos;
    AtualizarProduto;
    ShowMessage('Produto atualizado com sucesso!');
    Close;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar o produto: ' + E.Message);
  end;
end;

end.

