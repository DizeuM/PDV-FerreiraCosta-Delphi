unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, DbConnection, Home, System.IniFiles;

type
  TFormLogin = class(TForm)
    ImageFundo: TImage;
    InputUser: TEdit;
    InputSenha: TEdit;
    BtnEntrar: TSpeedButton;
    procedure BtnEntrarClick(Sender: TObject);
  private
    procedure ValidarLogin(const Usuario, Senha: string);
    procedure SalvarIDNoINI(const ID: Integer);
  public
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}

procedure TFormLogin.SalvarIDNoINI(const ID: Integer);
var
  IniFile: TIniFile;
  AppPath: string;
begin
  AppPath := ExtractFilePath(Application.ExeName);
  IniFile := TIniFile.Create(AppPath + 'Config.ini');
  try
    IniFile.WriteInteger('Login', 'VendedorID', ID);
  finally
    IniFile.Free;
  end;
end;

procedure TFormLogin.ValidarLogin(const Usuario, Senha: string);
var
  NomeVendedor: string;
  VendedorID: Integer;
begin
  with DataModule1.QueryLogin do
  begin
    Close;

    SQL.Text := 'SELECT id, nome FROM VENDEDOR WHERE usuario = :usuario AND senha = :senha';
    Parameters.ParamByName('usuario').Value := Usuario;
    Parameters.ParamByName('senha').Value := Senha;
    Open;

    if not IsEmpty then
    begin
      VendedorID := FieldByName('id').AsInteger;
      NomeVendedor := FieldByName('nome').AsString;

      SalvarIDNoINI(VendedorID);

      FormHome := TFormHome.Create(nil);
      try
        FormHome.InputNomeVendedor.Text := NomeVendedor;
        FormHome.Show;

        Self.Hide;
      except
        FormHome.Free;
        raise;
      end;
    end
    else
    begin
      ShowMessage('Usuário ou senha inválidos!');
    end;
  end;
end;

procedure TFormLogin.BtnEntrarClick(Sender: TObject);
begin
  try
    if Trim(InputUser.Text) = '' then
      raise Exception.Create('O campo de usuário não pode estar vazio.');

    if Trim(InputSenha.Text) = '' then
      raise Exception.Create('O campo de senha não pode estar vazio.');

    ValidarLogin(Trim(InputUser.Text), Trim(InputSenha.Text));
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

end.

