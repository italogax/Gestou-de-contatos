unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  Tform1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    txt_OBS: TMemo;
    txt_ID: TEdit;
    txt_NOME: TEdit;
    txt_TELEFONE: TEdit;
    txt_EMAIL: TEdit;
    FDConnection1: TFDConnection;
    FDContatos: TFDTable;
    DataSource1: TDataSource;
    btn_NOVO: TButton;
    btn_SALVAR: TButton;
    conexao: TLabel;
    btn_AVAN�AR: TButton;
    btn_ANTERIOR: TButton;
    btn_DELETE: TButton;
    BTN_EDITAR: TButton;
    btn_CANCELAR: TButton;
    txt_PROCURA: TEdit;
    SpeedButton1: TSpeedButton;
    DBGrid1: TDBGrid;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    img_FOTO: TImage;
    SpeedButton3: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure bloqueia;
    procedure limpa;
    procedure carrega;
    procedure FormCreate(Sender: TObject);
    procedure btn_AVAN�ARClick(Sender: TObject);
    procedure btn_ANTERIORClick(Sender: TObject);
    procedure btn_NOVOClick(Sender: TObject);
    procedure btn_SALVARClick(Sender: TObject);
    procedure FDContatosBeforePost(DataSet: TDataSet);
    procedure btn_DELETEClick(Sender: TObject);
    procedure BTN_EDITARClick(Sender: TObject);
    procedure btn_CANCELARClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form1: Tform1;
  estado: integer;

implementation

{$R *.dfm}

procedure Tform1.limpa;
begin
txt_ID.text         := '';
txt_NOME.text       := '';
txt_EMAIL.text      := '';
txt_TELEFONE.text   := '';
txt_OBS.text        := '';
end;


procedure Tform1.SpeedButton1Click(Sender: TObject);
begin
if fdcontatos.FindKey([txt_PROCURA.text]) then
    carrega
else
  showmessage('N�o encontrado')

end;

procedure Tform1.SpeedButton2Click(Sender: TObject);
begin
form1.Close;
end;

procedure Tform1.SpeedButton3Click(Sender: TObject);
begin
opendialog1.Execute();
//showmessage (opendialog1.FileName);
img_FOTO.Picture.LoadFromFile(opendialog1.FileName);
fdcontatos.Edit;
fdcontatos.FieldByName('foto').Value := opendialog1.FileName;
fdcontatos.Post;
end;

procedure Tform1.bloqueia;
begin
txt_NOME.Enabled       := not txt_NOME.Enabled;
txt_EMAIL.Enabled      := not txt_EMAIL.Enabled;
txt_TELEFONE.Enabled   := not txt_TELEFONE.Enabled;
txt_OBS.Enabled        := not txt_OBS.Enabled;
end;

procedure Tform1.carrega;
begin
txt_ID.text         := fdcontatos.FieldByName('id').Value;
txt_NOME.text       := fdcontatos.FieldByName('nome').Value;
txt_EMAIL.text      := fdcontatos.FieldByName('email').Value;
txt_TELEFONE.text   := fdcontatos.FieldByName('telefone').Value;
if fdcontatos.FieldByName('observacoes').Value = Null then
  txt_OBS.text := ''
else
  txt_OBS.text := fdcontatos.FieldByName('observacoes').Value;

if fdcontatos.FieldByName('foto').Value <> null then
  begin
    if fileexists(fdcontatos.FieldByName('foto').Value) then
      img_FOTO.Picture.LoadFromFile(fdcontatos.FieldByName('foto').Value)
  end
else
  img_FOTO.Picture.LoadFromFile('C:\Users\�talo\OneDrive\Documentos\Embarcadero\Studio\Projects\Win32\Debug\img\sem-foto.png');
end;




procedure Tform1.DBGrid1DblClick(Sender: TObject);
begin
carrega;
end;

procedure Tform1.FDContatosBeforePost(DataSet: TDataSet);
begin
fdcontatos.FieldByName('nome').Value         := txt_NOME.Text;
fdcontatos.FieldByName('email').Value        := txt_EMAIL.Text;
fdcontatos.FieldByName('telefone').Value     := txt_TELEFONE.Text;
fdcontatos.FieldByName('observacoes').Value  := txt_OBS.Text;
end;

procedure Tform1.FormCreate(Sender: TObject);
begin
fdconnection1.Params.Database := GetCurrentDir + '\assets\contatos.mdb';
fdconnection1.Connected := true;
fdcontatos.TableName := 'contatos';
fdcontatos.Active := true;

if fdconnection1.Connected = true then
begin
conexao.Caption := 'Conectado';
carrega;
end;
end;

procedure Tform1.btn_ANTERIORClick(Sender: TObject);
begin
fdcontatos.Prior;
carrega;
end;

procedure Tform1.btn_AVAN�ARClick(Sender: TObject);
begin
fdcontatos.Next;
carrega;
end;

procedure Tform1.btn_CANCELARClick(Sender: TObject);
begin
limpa;
if estado = 1 then
  fdcontatos.Prior;

fdcontatos.Prior;
carrega;
bloqueia;
estado := 0;
end;

procedure Tform1.btn_DELETEClick(Sender: TObject);
begin
fdcontatos.Delete;
carrega;
end;

procedure Tform1.BTN_EDITARClick(Sender: TObject);
begin
bloqueia;
fdcontatos.Edit;
end;

procedure Tform1.btn_NOVOClick(Sender: TObject);
begin
fdcontatos.Insert;
bloqueia;
limpa;
estado := 1;    // 1 = post.
end;

procedure Tform1.btn_SALVARClick(Sender: TObject);
begin
fdcontatos.Post;
bloqueia;
showmessage ('Dados salvos com sucesso!');
end;

end.

