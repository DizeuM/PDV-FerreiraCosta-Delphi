unit CriarProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Data.DB, Data.Win.ADODB, Vcl.Menus;

type
  TFormCriarProduto = class(TForm)
    ImageFundo: TImage;
    InputProdId: TEdit;
    InputProdNome: TEdit;
    InputProdPrecoUn: TEdit;
    InputProdQnt: TEdit;
    BtnCriar: TSpeedButton;
    InputProdCategoria: TComboBox;
    inputProdFornecedor: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure BtnCriarClick(Sender: TObject);
  private
    function GetUltimoIdProduto: Integer;
    procedure ValidarCampos;
    procedure InserirProduto;
  public
  end;

var
  FormCriarProduto: TFormCriarProduto;

implementation

{$R *.dfm}

uses
  DbConnection, Utils, ConsultarEstoque,  Vcl.Themes;

function TFormCriarProduto.GetUltimoIdProduto: Integer;
begin
  DataModule1.QueryCriarProduto.Close;
  DataModule1.QueryCriarProduto.SQL.Text := 'SELECT MAX(id) AS UltimoID FROM PRODUTO_ESTOQUE';
  DataModule1.QueryCriarProduto.Open;
  Result := DataModule1.QueryCriarProduto.FieldByName('UltimoID').AsInteger;
end;

procedure TFormCriarProduto.FormShow(Sender: TObject);
begin
  InputProdId.Text := IntToStr(GetUltimoIdProduto + 1);

  CarregarCategorias(InputProdCategoria);
  CarregarFornecedores(InputProdFornecedor);
end;

procedure TFormCriarProduto.ValidarCampos;
begin
  if Trim(InputProdNome.Text) = '' then
    raise Exception.Create('O nome do produto é obrigatório.');
  if Trim(InputProdCategoria.Text) = '' then
    raise Exception.Create('A categoria do produto é obrigatória.');
  if Trim(InputProdFornecedor.Text) = '' then
    raise Exception.Create('O fornecedor do produto é obrigatório.');
  if Trim(InputProdQnt.Text) = '' then
    raise Exception.Create('A quantidade é obrigatória.');
  if Trim(InputProdPrecoUn.Text) = '' then
    raise Exception.Create('O preço unitário é obrigatório.');
end;

procedure TFormCriarProduto.InserirProduto;
var
  PrecoUn: Double;
  Qnt: Integer;
begin
  PrecoUn := StrToFloat(InputProdPrecoUn.Text);
  Qnt := StrToInt(InputProdQnt.Text);

  DataModule1.QueryCriarProduto.Close;
  DataModule1.QueryCriarProduto.SQL.Text :=
    'INSERT INTO PRODUTO_ESTOQUE (descricao, categoria, fornecedor, valor_un, qnt_estoque) ' +
    'VALUES (:descricao, :categoria, :fornecedor, :valor_un, :qnt_estoque)';
  DataModule1.QueryCriarProduto.Parameters.ParamByName('descricao').Value := InputProdNome.Text;
  DataModule1.QueryCriarProduto.Parameters.ParamByName('categoria').Value := InputProdCategoria.Text;
  DataModule1.QueryCriarProduto.Parameters.ParamByName('fornecedor').Value := InputProdFornecedor.Text;
  DataModule1.QueryCriarProduto.Parameters.ParamByName('valor_un').Value := PrecoUn;
  DataModule1.QueryCriarProduto.Parameters.ParamByName('qnt_estoque').Value := Qnt;

  DataModule1.QueryCriarProduto.ExecSQL;
end;

procedure TFormCriarProduto.BtnCriarClick(Sender: TObject);
begin
  try
    ValidarCampos;
    InserirProduto;
    ShowMessage('Produto adicionado com sucesso!');
    Close;
  except
    on E: Exception do
      ShowMessage('Erro ao adicionar o produto: ' + E.Message);
  end;
end;

end.

