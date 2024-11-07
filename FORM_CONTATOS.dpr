program FORM_CONTATOS;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {form1},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Tform1, form1);
  Application.Run;
end.
