unit Utils;

interface

uses
  Vcl.StdCtrls;

procedure CarregarCategorias(InputProdCategoria: TComboBox);
procedure CarregarFornecedores(InputProdFornecedor: TComboBox);

implementation

procedure CarregarCategorias(InputProdCategoria: TComboBox);
begin
  InputProdCategoria.Items.Clear;
  InputProdCategoria.Items.Add('');
  InputProdCategoria.Items.Add('Eletro e eletrônicos');
  InputProdCategoria.Items.Add('Utilidades domésticas');
  InputProdCategoria.Items.Add('Móveis e decoração');
  InputProdCategoria.Items.Add('Cama, mesa e banho');
  InputProdCategoria.Items.Add('Ferramentas e EPI');
  InputProdCategoria.Items.Add('Automotivo');
  InputProdCategoria.Items.Add('Materiais elétricos');
  InputProdCategoria.Items.Add('Materiais hidráulicos e bombas');
  InputProdCategoria.Items.Add('Pisos e revestimentos');
  InputProdCategoria.Items.Add('Louças, metais e acessórios');
  InputProdCategoria.Items.Add('Portas, janelas e fechaduras');
  InputProdCategoria.Items.Add('Tintas e químicos');
end;

procedure CarregarFornecedores(InputProdFornecedor: TComboBox);
begin
  InputProdFornecedor.Items.Clear;
  InputProdFornecedor.Items.Add('');
  InputProdFornecedor.Items.Add('10230480001960');
  InputProdFornecedor.Items.Add('20510490001120');
  InputProdFornecedor.Items.Add('30780360001550');
end;

end.

