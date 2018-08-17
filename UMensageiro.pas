unit UMensageiro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, Vcl.StdCtrls,
  IdCustomTCPServer, IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, Winapi.WinSock,
  Vcl.Samples.Gauges, Winapi.MMSystem, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Datasnap.DBClient, Vcl.Buttons, Winapi.ShellAPI, Vcl.Imaging.jpeg, Vcl.Clipbrd,
  JvExStdCtrls, JvRichEdit, Vcl.ActnList, System.Actions, System.ImageList, Vcl.ImgList;

  type
  TFlashWInfo = record
    cbSize    : LongInt;
    hWndMe    : LongInt;
    dwFlags   : LongInt;
    uCount    : LongInt;
    dwTimeout : LongInt;
  end;
type
  TFMensageiro = class(TForm)
    IdTCPClient: TIdTCPClient;
    IdTCPServer: TIdTCPServer;
    mIp: TMaskEdit;
    lMensagem: TLabel;
    Label1: TLabel;
    lbUser: TLabel;
    Timer: TTimer;
    cdLista: TClientDataSet;
    dslista: TDataSource;
    cdListaIp: TStringField;
    GridLista: TDBGrid;
    sbExcIp: TSpeedButton;
    sbAddIp: TSpeedButton;
    meIpsGrupo: TMaskEdit;
    Label4: TLabel;
    cbAtivar: TCheckBox;
    IdTCPClientImagem: TIdTCPClient;
    IdTCPServerImagem: TIdTCPServer;
    opArquivo: TOpenDialog;
    Label5: TLabel;
    mkArquivo: TMaskEdit;
    sbProcurarArquivo: TSpeedButton;
    sbLimparImagem: TSpeedButton;
    Button1: TButton;
    eOrigem: TEdit;
    TrayIcon: TTrayIcon;
    cdListaDescricao: TStringField;
    meDescricao: TMaskEdit;
    sbSalvarLista: TSpeedButton;
    Shape1: TShape;
    img: TImage;
    tbTransparencia: TTrackBar;
    rEscrever: TJvRichEdit;
    rRetorno: TJvRichEdit;
    ActionList: TActionList;
    ActionGrupo: TAction;
    ActionLimpar: TAction;
    ActionAtencao: TAction;
    ActionMinimizar: TAction;
    ActionImagem: TAction;
    ActionVisible: TAction;
    ActionIps: TAction;
    lDestino: TLabel;
    sbEnviar: TSpeedButton;
    ActionSilenciar: TAction;
    imgSom: TImage;
    imgSemSom: TImage;
    imgSilenciar: TImage;
    imgCript: TImage;
    imgt1: TImage;
    cdListaSel: TStringField;
    eUser: TEdit;
    iconesTray: TImageList;
    procedure bEnviarClick(Sender: TObject);
    procedure IdTCPServerConnect(AContext: TIdContext);
    procedure IdTCPServerExecute(AContext: TIdContext);
    procedure TimerTimer(Sender: TObject);
    procedure bLimparEscritaClick(Sender: TObject);
    procedure rEscreverKeyPress(Sender: TObject; var Key: Char);
    procedure rRetornoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbAddIpClick(Sender: TObject);
    procedure sbExcIpClick(Sender: TObject);
    procedure cbAtivarClick(Sender: TObject);
    procedure rEscreverClick(Sender: TObject);
    procedure IdTCPServerImagemConnect(AContext: TIdContext);
    procedure sbProcurarArquivoClick(Sender: TObject);
    procedure sbLimparImagemClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rRetornoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Invisivel(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure sbAtencaoClick(Sender: TObject);
    procedure sbSalvarListaClick(Sender: TObject);
    procedure GridListaDblClick(Sender: TObject);
    procedure sbImagemMostrarImagemClick(Sender: TObject);
    procedure imgDblClick(Sender: TObject);
    procedure tbTransparenciaChange(Sender: TObject);
    procedure ActionGrupoExecute(Sender: TObject);
    procedure ActionLimparExecute(Sender: TObject);
    procedure ActionAtencaoExecute(Sender: TObject);
    procedure ActionVisibleExecute(Sender: TObject);
    procedure ActionImagemExecute(Sender: TObject);
    procedure ActionMinimizarExecute(Sender: TObject);
    procedure ActionIpsExecute(Sender: TObject);
    procedure sbEnviarClick(Sender: TObject);
    procedure ActionSilenciarExecute(Sender: TObject);
    procedure imgt1DblClick(Sender: TObject);
    procedure GridListaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridListaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    Nid : TNotifyIconData;
    silenciar: Boolean;

    procedure AcaoEnviar;
    procedure Enviar(ip: string; add_retorno: Boolean; particular: Boolean);
    procedure EnviarImagem(ip: string; add_retorno: Boolean);
    procedure P_Constraints(l_form : TForm; l_heigth, l_width : integer);

    procedure ShowForm;
    procedure HideForm;
    procedure Minimizar;

    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure CarregarListaIps;

    procedure CarregarImagem(imagem: string);
    procedure LimparImagem;
    procedure AbrirImagem(imagem: String);

    function Criptografar(texto: string): string;
    function Descriptografar(texto: string): string;

    procedure BuscarImagemByTag(tag: string; rich : TJvRichEdit);
    procedure VerificarEscrita(rich : TJvRichEdit);

    function BitmapToRtf(graph:TBitmap):string;

    procedure MarcarTodos(marcar: Boolean);

  public
    { Public declarations }
    procedure IconTray(Msg: TMessage);
  end;

var
  FMensageiro: TFMensageiro;

const
  CODIGO_ALERTA: string = '[#SHOW_FORM#]';
  ini_tag = '<';
  fim_tag = '>';

  iconPadrao = 1;
  iconAlerta = 0;

implementation

{$R *.dfm}

procedure TFMensageiro.AbrirImagem(imagem: String);
var
  r: String;
begin
  case ShellExecute(Handle, nil, PChar(imagem), nil, nil, SW_SHOWNORMAL) of
    ERROR_FILE_NOT_FOUND: r := 'O arquivo específico não foi encontrado.';
    ERROR_PATH_NOT_FOUND: r := 'O caminho específico não foi encontrado.';
    ERROR_BAD_FORMAT: r := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED: r := 'Windows 95 only: The operating system denied access to the specified file.';
    SE_ERR_ASSOCINCOMPLETE: r := 'The filename association is incomplete or invalid.';
    SE_ERR_DDEBUSY: r := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
    SE_ERR_DDEFAIL: r := 'The DDE transaction failed.';
    SE_ERR_DDETIMEOUT: r := 'The DDE transaction could not be completed because the request timed out.';
    SE_ERR_DLLNOTFOUND: r := 'Windows 95 only: The specified dynamic-link library was not found.';
    SE_ERR_NOASSOC: r := 'There is no application associated with the given filename extension.';
    SE_ERR_OOM: r := 'Windows 95 only: There was not enough memory to complete the operation.';
    SE_ERR_SHARE: r := 'A sharing violation occurred.';
  else
    Exit;
  end;
    ShowMessage(r);
end;

procedure TFMensageiro.AcaoEnviar;
var
  i : Integer;
begin
  i := 0;

  if cbAtivar.Checked then begin
    cdLista.First;

    while not cdLista.Eof do begin
      if cdListaSel.AsString = 'S' then begin
        Inc(i);
        Enviar(cdListaIp.AsString, i = 1, False);
      end;
      cdLista.Next;
    end;
  end
  else begin
    Enviar(mIp.Text, True, True);
  end;

  rEscrever.Clear;
  TrayIcon.Animate := False;
end;

procedure TFMensageiro.ActionAtencaoExecute(Sender: TObject);
begin
  rEscrever.Text := CODIGO_ALERTA;
  AcaoEnviar;
end;

procedure TFMensageiro.ActionGrupoExecute(Sender: TObject);
begin
  cbAtivar.Checked := not cbAtivar.Checked;

  MarcarTodos(cbAtivar.Checked);
  if not cbAtivar.Checked then  
    lDestino.Caption := 'Enviar particular'
  else
    lDestino.Caption := 'Enviar grupo' ;

  rEscrever.SetFocus;
end;

procedure TFMensageiro.ActionImagemExecute(Sender: TObject);
begin
  if FMensageiro.Height = 445 then
    P_Constraints(Self, 250 , Self.Width)
  else
    P_Constraints(Self, 445 , Self.Width);
end;

procedure TFMensageiro.ActionIpsExecute(Sender: TObject);
begin
  if FMensageiro.Width >= 520 then
    P_Constraints(Self, Self.Height, 305)
  else
    P_Constraints(Self, Self.Height, 520);
end;

procedure TFMensageiro.ActionLimparExecute(Sender: TObject);
begin
  rRetorno.Clear;
  rEscrever.Clear;
end;

procedure TFMensageiro.ActionMinimizarExecute(Sender: TObject);
begin
  Minimizar;
  TrayIcon.Animate := False;
end;

procedure TFMensageiro.ActionSilenciarExecute(Sender: TObject);
begin
  silenciar := not silenciar;

  if not silenciar then begin
    imgSilenciar.Picture := imgSom.Picture;
    silenciar := False;
  end
  else begin
    imgSilenciar.Picture := imgSemSom.Picture;
    silenciar := True;
  end;

  Application.ProcessMessages;
end;

procedure TFMensageiro.ActionVisibleExecute(Sender: TObject);
begin
  if tbTransparencia.Position >= 150 then
    tbTransparencia.Position := 0
  else
    tbTransparencia.Position := 150;
end;

procedure TFMensageiro.bEnviarClick(Sender: TObject);
var
  i : Integer;
begin
  i := 0;

  if cbAtivar.Checked then begin
    cdLista.First;

    while not cdLista.Eof do begin
      Inc(i);
      Enviar(cdListaIp.AsString, i = 1, False);
      cdLista.Next;
    end;
  end
  else begin
    Enviar(mIp.Text, True, True);
  end;

  rEscrever.Clear;
end;

function TFMensageiro.BitmapToRtf(graph: TBitmap): string;
var
 bi, bb, rtf:string;
 bis, bbs:cardinal;
 achar: string;
 HexGraph: string;
 I:Integer;
begin
  GetDIBSizes(graph.Handle, bis, bbs);
  SetLength(bi,bis);
  SetLength(bb,bbs);
  GetDIB(graph.Handle, graph.Palette, PChar(bi)^, PChar(bb)^);
  rtf:='{\rtf1 {\pict\dibitmap ';
  SetLength(HexGraph,(Length(bb) + Length(bi)) * 2);

  I:=2;

  For bis:=1 to Length(bi) do
  begin
    achar:=Format('%x',[Integer(bi[bis])]);

    if Length(achar)=1 then
      achar:='0'+achar;

    HexGraph[I-1]:= Char(achar[1]);
    HexGraph[I]:= Char(achar[2]);
    Inc(I,2);
  end;
  For bbs:=1 to Length(bb) do
  begin
    achar:=Format('%x',[Integer(bb[bbs])]);
    if Length(achar)=1 then
      achar:='0'+achar;

    HexGraph[I-1] := Char(achar[1]);
    HexGraph[I]   := Char(achar[2]);
    Inc(I,2);
  end;

  rtf:=rtf + HexGraph + ' }}';
  Result:=rtf;
end;

procedure TFMensageiro.bLimparEscritaClick(Sender: TObject);
begin
  rEscrever.Clear;
end;

procedure TFMensageiro.BuscarImagemByTag(tag: string; rich : TJvRichEdit);
var
  img: TImage;
begin
  img := TImage(Self.FindComponent('img'+Copy(tag,2,Pos('>', tag)-1)));
  if tag = '<t1>' then
    Clipboard.Assign(img);

  rich.PasteFromClipboard;
end;

procedure TFMensageiro.Button1Click(Sender: TObject);
begin
  if cbAtivar.Checked then begin
    cdLista.First;

    while not cdLista.Eof do begin
      EnviarImagem(cdListaIp.AsString, True);
      cdLista.Next;
    end;
  end
  else begin
    EnviarImagem(mIp.Text, True);
  end;
end;

procedure TFMensageiro.CarregarImagem(imagem: string);
var
  jpg : TJPegImage;
begin
  try
    jpg := TJPegImage.Create;
    jpg.LoadFromFile(imagem);
    img.Picture.Assign(jpg);
  finally
    FreeAndNil(jpg);
  end;
end;

procedure TFMensageiro.CarregarListaIps;
var
  i: Integer;
  lista: TStrings;
begin
  try
    if cdLista.Active then
      Exit;

    lista := TStringList.Create;
    lista.LoadFromFile('list.ini');

    if lista <> nil then begin
      if not cdLista.Active then
        cdLista.CreateDataSet;

      for i := 0 to lista.Count -1 do begin
        if Copy(lista[i],0,1) = '*' then begin
          eOrigem.Text := Copy(lista[i], 2, length(lista[i]));
          Continue;
        end;

        cdLista.Append;
        cdListaIp.AsString := Copy(lista[i],0, Pos(';',lista[i])-1);
        cdListaDescricao.AsString := Copy(lista[i],Pos(';',lista[i])+1, Length(lista[i]));
        cdListaSel.AsString := 'N';
        cdLista.Post;
      end;
      cdLista.First;
    end;
  except
    //
  end;
end;

procedure TFMensageiro.cbAtivarClick(Sender: TObject);
begin
  if not cdLista.Active then
    cdLista.CreateDataSet;

  MarcarTodos(cbAtivar.Checked);

  if not cbAtivar.Checked then
    lDestino.Caption := 'Enviar particular'
  else
    lDestino.Caption := 'Enviar grupo' ;

  rEscrever.SetFocus;
end;

function TFMensageiro.Criptografar(texto: string): string;
Label fim;
var
  key_len : Integer;
  key_pos : Integer;
  offset : Integer;
  dest, key : string;
  src_pos : Integer;
  src_asc : Integer;
  range : Integer;
begin
  if (texto = '') then begin
    Result:= '';
    goto fim;
  end;
  key := '{684E23SS-540F-4ASF-9512-EAAAXC4712F1}';
  dest := '';
  key_len := Length(key);
  key_pos := 0;
  range := 256;

  Randomize;
  offset := Random(range);
  dest := Format('%1.2x',[offset]);
  for src_pos := 1 to Length(texto) do begin
    Application.ProcessMessages;
    src_asc := (Ord(texto[src_pos]) + offset) mod 255;
    if key_pos < key_len then
      key_pos := key_pos + 1
    else
      key_pos := 1;
    src_asc := src_asc xor Ord(key[key_pos]);
    dest := dest + Format('%1.2x',[src_asc]);
    offset := src_asc;
  end;
  Result:= dest;
fim:
end;

function TFMensageiro.Descriptografar(texto: string): string;
Label fim;
var
  key_len : Integer;
  key_pos : Integer;
  offset : Integer;
  dest, key : string;
  src_pos : Integer;
  src_asc : Integer;
  tmp_src_asc : Integer;
begin
  if (texto = '') then begin
    Result:= '';
    goto fim;
  end;
  key := '{684E23SS-540F-4ASF-9512-EAAAXC4712F1}';
  dest := '';
  key_len := Length(key);
  key_pos := 0;
  offset := StrToInt('$' + copy(texto,1,2));//<--------------- adiciona o $ entra as aspas simples
  src_pos := 3;
  repeat
    src_asc := StrToInt('$' + copy(texto,src_pos,2));//<--------------- adiciona o $ entra as aspas simples
    if (key_pos < key_len) then
      key_pos := key_pos + 1
    else
      key_pos := 1;
    tmp_src_asc := src_asc xor Ord(key[key_pos]);
    if tmp_src_asc <= offset then
      tmp_src_asc := 255 + tmp_src_asc - offset
    else
      tmp_src_asc := tmp_src_asc - offset;
    dest := dest + Chr(tmp_src_asc);
    offset := src_asc;
    src_pos := src_pos + 2;
  until (src_pos >= Length(texto));

  Result:= dest;

fim:
end;

procedure TFMensageiro.Enviar(ip: string; add_retorno: Boolean; particular: Boolean);
var
  caracter: string;
begin
  with IdTCPClient do
  try
    caracter := '';
    Host := ip;
    Connect;
    
    if particular then
      caracter := ' * ';

    with Socket do begin
      WriteLn(Criptografar(Trim(eOrigem.Text+ caracter +' - '+ rEscrever.Text)));

      if add_retorno then begin
        if Pos(CODIGO_ALERTA, Trim(rEscrever.Text)) > 0 then begin
          rRetorno.SelAttributes.Color := clRed;
          rRetorno.Lines.Add('(Você solicitou anteção.)');
        end
        else begin
          rRetorno.SelAttributes.Color := clNavy;
          rRetorno.Lines.Add(eOrigem.Text +' - '+ Trim(rEscrever.Text));
        end;
      end;
    end;

    SendMessage(rRetorno.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    rRetorno.SelStart := Length(rRetorno.Text);

    Disconnect;
  except
    rRetorno.SelAttributes.Color := clRed;
    rRetorno.Lines.Add('O Servidor não responde - verifique o IP ('+ ip +')');
  end;
end;

procedure TFMensageiro.EnviarImagem(ip: string; add_retorno: Boolean);
var
  stream: TfileStream;
begin
  if mkArquivo.Text = '' then begin
    ShowMessage('É necessário haver um arquivo capturado!');
    Exit;
  end;

  with IdTCPClientImagem do
  try
    Host := ip;
    Connect;

    with Socket do begin
      try
        IOHandler.LargeStream := True;
        stream := TFileStream.Create(Trim(mkArquivo.Text), 0);

        IOHandler.Write(stream, 0, True);
      finally
        FreeAndNil(stream);
      end;

      if add_retorno then begin
        rRetorno.SelAttributes.Color := clGreen;
        rRetorno.SelAttributes.Style := [fsBold];
        rRetorno.Lines.Add('Arquivo ' + ExtractFileName(mkArquivo.Text) + ' foi enviado, ip: '+ ip +'!');
      end;
    end;
    Disconnect;

  except
    rRetorno.SelAttributes.Color := clRed;
    rRetorno.Lines.Add('O Servidor não responde - verifique o IP ('+ ip +')');
  end;
end;

procedure TFMensageiro.FormCreate(Sender: TObject);
begin
  Self.Height := 250;
  P_Constraints(Self, Self.Height, Self.Width);
  opArquivo.Filter := 'JPG Image File (*.jpg)|*.jpg';
  tbTransparencia.Position := Self.AlphaBlendValue;
  silenciar := False;
  Minimizar;
end;

procedure TFMensageiro.FormDestroy(Sender: TObject);
begin
  Nid.uFlags := 0;
  Shell_NotifyIcon(Nim_Delete, @nid);
end;

procedure TFMensageiro.FormShow(Sender: TObject);
begin
  GridLista.Color := clCream;
  CarregarListaIps;
end;

procedure TFMensageiro.GridListaDblClick(Sender: TObject);
begin
  if cdLista.RecordCount = 0 then
    Exit;

  mIp.Text := cdListaIp.AsString;
  eUser.Text := cdListaDescricao.AsString;
end;

procedure TFMensageiro.GridListaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not cdLista.Active then
    Exit;

  GridLista.Canvas.Font.Style := [fsBold];

  if cdListaSel.AsString = 'S' then
    GridLista.Canvas.Font.Color := clGreen
  else
    GridLista.Canvas.Font.Color := clRed;

  GridLista.Canvas.FillRect(Rect);
  GridLista.DefaultDrawDataCell(Rect, Column.Field, State);
end;

procedure TFMensageiro.GridListaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not cdLista.Active then
    Exit;

  if key = VK_SPACE then begin
    cdLista.Edit;
    if cdListaSel.AsString = 'N' then
      cdListaSel.AsString := 'S'
    else
      cdListaSel.AsString := 'N';
    cdLista.Post;
  end;
end;

procedure TFMensageiro.HideForm;
begin
  TrayIcon.Visible := True;
  WindowState := wsMinimized;
  Hide;
end;

procedure TFMensageiro.IconTray(Msg: TMessage);
var
  Pt:Tpoint;
begin
  if (Msg.LParamHi = wm_rbuttondown) then begin
    GetCursorPos(Pt);
  end;
end;

procedure TFMensageiro.IdTCPServerConnect(AContext: TIdContext);
var
  ip: string;
  mensagem: string;
begin
  with AContext.Connection.Socket do
  begin
    if cbAtivar.Checked then
      ip := cdListaIp.AsString
    else
      ip := Trim(mIp.Text);

    mensagem := readLn();
    mensagem := Descriptografar(mensagem);

    if Pos(CODIGO_ALERTA, mensagem) > 0 then begin
      rRetorno.SelAttributes.Color := clRed;
      rRetorno.Lines.Add('(' + Trim(Copy(mensagem, 1, Pos('-', mensagem) - 1)) + ' solicitou sua atenção.)');
      if silenciar <> True then
        ShowForm;
    end
    else begin
      rRetorno.SelAttributes.Color := clGreen;
      rRetorno.Lines.Add(mensagem);
    end;

    if not silenciar then begin
      SetForegroundWindow(FMensageiro.Handle);
      SendMessage(rRetorno.Handle, WM_VSCROLL, SB_BOTTOM, 0);
      rRetorno.SelStart := Length(rRetorno.Text);
      Timer.Enabled := True;
      
      if WindowState = wsMinimized then
        TrayIcon.Animate := True;
    end;
  end;
end;

procedure TFMensageiro.IdTCPServerExecute(AContext: TIdContext);
begin
  if Timer.Enabled then
    Timer.Enabled := False;
end;

procedure TFMensageiro.IdTCPServerImagemConnect(AContext: TIdContext);
var
  ip: string;
  fStream: TMemoryStream;
  nome_arquivo: string;

  function MemoryStreamToString(M: TMemoryStream): string;
  begin
    SetString(Result, PChar(M.Memory), M.Size div SizeOf(Char));
  end;

begin
  with AContext.Connection.Socket do begin
    if cbAtivar.Checked then
      ip := cdListaIp.AsString
    else
      ip := Trim(mIp.Text);

    fStream := TMemoryStream.Create;
    try
      DeleteFile('imagem.jpg');
      AContext.Connection.IOHandler.LargeStream := True;
      AContext.Connection.IOHandler.ReadStream(fStream, -1, False);
      nome_arquivo := MemoryStreamToString(fStream);
      fStream.SaveToFile('imagem.jpg');

      rRetorno.SelAttributes.Color := clRed;
      rRetorno.Lines.Add('(Você recebeu uma imagem.)');

      CarregarImagem('imagem.jpg');
    finally
      fStream.Free;
    end;

    Timer.Enabled := True;
  end;
end;

procedure TFMensageiro.imgDblClick(Sender: TObject);
begin
  if mkArquivo.Text <> '' then
    AbrirImagem('imagem.jpg');
end;

procedure TFMensageiro.imgt1DblClick(Sender: TObject);
var
  SS: TStringStream;
begin
  try
    SS:= TStringStream.Create(BitmapToRtf(TImage(Sender).Picture.Bitmap));
    rEscrever.PlainText:=False;
    rEscrever.StreamMode:=[smSelection];
    rEscrever.Lines.LoadFromStream(SS);

    SS.Free;
  Except
  end;
end;

procedure TFMensageiro.Invisivel(Sender: TObject);
begin
  TrayIcon.Visible := True;
end;

procedure TFMensageiro.LimparImagem;
begin
  img.Picture := nil;
end;

procedure TFMensageiro.MarcarTodos(marcar: Boolean);
begin
  if not cdLista.Active then
    Exit;

  cdLista.First;

  while not cdLista.Eof do begin
    cdLista.Edit;
    if marcar then
      cdListaSel.AsString := 'S'
    else
      cdListaSel.AsString := 'N';
    cdLista.post;
    cdLista.Next;
  end;

  cdLista.First;
end;

procedure TFMensageiro.Minimizar;
begin
  Self.WindowState := wsMinimized;
  TrayIcon.Visible := True;
  TrayIcon.ShowBalloonHint;
  HideForm;
end;

procedure TFMensageiro.P_Constraints(l_form: TForm; l_heigth, l_width: Integer);
begin
  l_form.WindowState := wsNormal;
  l_form.Position := poScreenCenter;
  l_form.Constraints.MaxHeight := l_heigth;
  l_form.Constraints.MinHeight := l_heigth;
  l_form.Constraints.MaxWidth := l_width;
  l_form.Constraints.MinWidth := l_width;
end;

procedure TFMensageiro.rEscreverClick(Sender: TObject);
begin
  if Timer.Enabled then
    Timer.Enabled := False;

  TrayIcon.Animate := False;
end;

procedure TFMensageiro.rEscreverKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (Trim(rEscrever.Text) <> '') then begin
    Key := #0;
    AcaoEnviar;
  end;
end;

procedure TFMensageiro.rRetornoChange(Sender: TObject);
begin
  SendMessage(rRetorno.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  Application.ProcessMessages;
end;

procedure TFMensageiro.rRetornoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

procedure TFMensageiro.sbAddIpClick(Sender: TObject);
begin
  if not cdLista.Active then
    cdLista.CreateDataSet;

  cdLista.Append;
  cdListaIp.AsString        := Trim(meIpsGrupo.Text);
  cdListaDescricao.AsString := Trim(meDescricao.Text);
  cdLista.Post;
end;

procedure TFMensageiro.sbAtencaoClick(Sender: TObject);
begin
  rEscrever.Text := CODIGO_ALERTA;
  AcaoEnviar;
end;

procedure TFMensageiro.sbEnviarClick(Sender: TObject);
begin
  AcaoEnviar;
end;

procedure TFMensageiro.sbExcIpClick(Sender: TObject);
begin
  if Trim(cdListaIp.AsString) = '' then
    Exit;

  cdLista.Delete;
end;

procedure TFMensageiro.sbImagemMostrarImagemClick(Sender: TObject);
begin
  if FMensageiro.Height = 445 then
    P_Constraints(Self, 250 , Self.Width)
  else
    P_Constraints(Self, 445 , Self.Width);
end;

procedure TFMensageiro.sbLimparImagemClick(Sender: TObject);
begin
  mkArquivo.Clear;
  LimparImagem;
end;

procedure TFMensageiro.sbProcurarArquivoClick(Sender: TObject);
begin
  if opArquivo.Execute then begin
    mkArquivo.Text := opArquivo.Files.Text;
    CarregarImagem(opArquivo.FileName);
  end;
end;

procedure TFMensageiro.sbSalvarListaClick(Sender: TObject);
var
  i: Integer;
  lista: TStrings;
begin
  if cdLista.RecordCount = 0 then
    Exit;

  lista := TStringList.Create;

  try
    lista.Add('*'+Trim(eOrigem.Text));

    cdLista.First;
    for i := 0 to cdLista.RecordCount -1 do begin
      lista.Add(cdListaIp.AsString+';'+cdListaDescricao.AsString);
      cdLista.Next;
    end;
  finally
    cdLista.First;
    lista.SaveToFile('list.ini');
    lista.Free;
  end;
end;

procedure TFMensageiro.ShowForm;
begin
  TrayIcon.Visible := False;
  WindowState := wsNormal;
  Show;
  Application.BringToFront;
end;

procedure TFMensageiro.tbTransparenciaChange(Sender: TObject);
begin
  Self.AlphaBlendValue := tbTransparencia.Position;
end;

procedure TFMensageiro.TimerTimer(Sender: TObject);
begin
  TrayIcon.ShowBalloonHint();
end;

procedure TFMensageiro.TrayIconDblClick(Sender: TObject);
begin
  if (WindowState = wsMinimized) then
    ShowForm
  else
    HideForm;
end;

procedure TFMensageiro.VerificarEscrita(rich: TJvRichEdit);
var
  i : integer;
  pos_ini: Integer;
  pos_fim: Integer;
  caracter: string;
  texto : string;
  e_tag : Boolean;
begin
  pos_ini := 0;
  pos_fim := 0;
  texto := '';
  e_tag := False;

  for i := 0 to Length(rich.Text) do begin
    caracter := Copy(rich.Text, i, 1);

    if (e_tag) and ((caracter = ini_tag) or (caracter = fim_tag)) then begin
      e_tag := True;

      if caracter = ini_tag then
        pos_ini := i
      else if caracter = fim_tag then begin
        pos_fim := i;
        e_tag := False;
      end;

      if (pos_ini <> 0) and (pos_fim <> 0) then begin
        BuscarImagemByTag(Copy(rich.Text, pos_ini, pos_fim - pos_ini), rich);
        pos_ini := 0;
        pos_fim := 0;
      end;
    end
    else begin
      texto := texto + caracter;
    end;

    rich.Text := texto;
  end;
end;

procedure TFMensageiro.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then begin
    with Self do begin
      HideForm;
    end;
  end
  else if Msg.CmdType = SC_CLOSE then
    Self.Close
  else
    inherited;
end;

end.


