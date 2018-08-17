program Mensageiro;

uses
  Vcl.Forms,
  UMensageiro in 'UMensageiro.pas' {FMensageiro},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMensageiro, FMensageiro);
  Application.Run;
end.
