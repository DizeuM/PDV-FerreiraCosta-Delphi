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
  InputProdCategoria.Items.Add('Eletro e eletr�nicos');
  InputProdCategoria.Items.Add('Utilidades dom�sticas');
  InputProdCategoria.Items.Add('M�veis e decora��o');
  InputProdCategoria.Items.Add('Cama, mesa e banho');
  InputProdCategoria.Items.Add('Ferramentas e EPI');
  InputProdCategoria.Items.Add('Automotivo');
  InputProdCategoria.Items.Add('Materiais el�tricos');
  InputProdCategoria.Items.Add('Materiais hidr�ulicos e bombas');
  InputProdCategoria.Items.Add('Pisos e revestimentos');
  InputProdCategoria.Items.Add('Lou�as, metais e acess�rios');
  InputProdCategoria.Items.Add('Portas, janelas e fechaduras');
  InputProdCategoria.Items.Add('Tintas e qu�micos');
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

