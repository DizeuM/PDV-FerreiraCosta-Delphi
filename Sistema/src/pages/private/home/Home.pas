unit Home;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ConsultarEstoque, HistoricoPedidos,
  GerarPedido, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFormHome = class(TForm)
    ImageFundo: TImage;
    PanelBtnGerarPedido: TPanel;
    ImageGerarPedido: TImage;
    BtnGerarPedido: TSpeedButton;
    ImageHistoricoPedidos: TImage;
    BtnHistoricoPedidos: TSpeedButton;
    PanelHistoricoPedidos: TPanel;
    ImageConsultarProduto: TImage;
    BtnConsultarProduto: TSpeedButton;
    PanelConsultarProduto: TPanel;
    BtnSair: TSpeedButton;
    FrameConsultarEstoque1: TFrameConsultarEstoque;
    FrameGerarPedido1: TFrameGerarPedido;
    FrameHistoricoPedidos1: TFrameHistoricoPedidos;
    InputNomeVendedor: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure BtnGerarPedidoClick(Sender: TObject);
    procedure BtnHistoricoPedidosClick(Sender: TObject);
    procedure BtnConsultarProdutoClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);

  private
    procedure ToggleVisibility(ImageToShow: TImage; FrameToShow: TFrame);
  public
    { Public declarations }
  end;

var
  FormHome: TFormHome;

implementation

{$R *.dfm}
uses
  Login, IniFiles;

procedure TFormHome.BtnSairClick(Sender: TObject);
var
  IniFile: TIniFile;
  AppPath: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  IniFile := TIniFile.Create(AppPath + 'Config.ini');
  try
    IniFile.DeleteKey('Login', 'VendedorID');
  finally
    IniFile.Free;
  end;

  FormLogin.InputUser.Text := '';
  FormLogin.InputSenha.Text := '';
  FormLogin.Show;

  Self.Hide;
end;

procedure TFormHome.ToggleVisibility(ImageToShow: TImage; FrameToShow: TFrame);
begin
  ImageGerarPedido.Visible := False;
  ImageHistoricoPedidos.Visible := False;
  ImageConsultarProduto.Visible := False;

  FrameGerarPedido1.Visible := False;
  FrameHistoricoPedidos1.Visible := False;
  FrameConsultarEstoque1.Visible := False;

  ImageToShow.Visible := True;
  FrameToShow.Visible := True;
end;

procedure TFormHome.FormCreate(Sender: TObject);
begin
  ToggleVisibility(ImageGerarPedido, FrameGerarPedido1);

  PanelBtnGerarPedido.Visible := True;
  PanelHistoricoPedidos.Visible := True;
  PanelConsultarProduto.Visible := True;
end;

procedure TFormHome.BtnGerarPedidoClick(Sender: TObject);
begin
  ToggleVisibility(ImageGerarPedido, FrameGerarPedido1);
end;

procedure TFormHome.BtnHistoricoPedidosClick(Sender: TObject);
begin
  ToggleVisibility(ImageHistoricoPedidos, FrameHistoricoPedidos1);
end;

procedure TFormHome.BtnConsultarProdutoClick(Sender: TObject);
begin
  ToggleVisibility(ImageConsultarProduto, FrameConsultarEstoque1);
end;

end.

