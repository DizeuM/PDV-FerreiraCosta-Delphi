program Sistema;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  DbConnection in 'src\modules\DbConnection.pas' {DataModule1: TDataModule},
  Login in 'src\pages\public\login\Login.pas' {FormLogin},
  Home in 'src\pages\private\home\Home.pas' {FormHome},
  HistoricoPedidos in 'src\pages\private\historicoPedidos\HistoricoPedidos.pas' {FrameHistoricoPedidos: TFrame},
  GerarPedido in 'src\pages\private\gerarPedido\GerarPedido.pas' {FrameGerarPedido: TFrame},
  ConsultarEstoque in 'src\pages\private\consultarEstoque\ConsultarEstoque.pas' {FrameConsultarEstoque: TFrame},
  CriarProduto in 'src\pages\private\consultarEstoque\CriarProduto.pas' {FormCriarProduto},
  DetalhesProduto in 'src\pages\private\consultarEstoque\DetalhesProduto.pas' {FormDetalhesProduto},
  Utils in 'src\utils\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormHome, FormHome);
  Application.CreateForm(TFormCriarProduto, FormCriarProduto);
  Application.CreateForm(TFormDetalhesProduto, FormDetalhesProduto);
  Application.Run;
end.
