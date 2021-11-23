unit uFormChat;

{
  Project Aegys Remote Support.

  Created by Gilberto Rocha da Silva in 04/05/2017 based on project Allakore, has by objective to promote remote access
  and other resources freely to all those who need it, today maintained by a beautiful community. Listing below our
  higly esteemed collaborators:

  Gilberto Rocha da Silva (XyberX) (Creator of Aegys Project/Main Developer/Admin)
  Wendel Rodrigues Fassarella (wendelfassarella) (Creator of Aegys FMX/CORE Developer)
  Rai Duarte Jales (Ra� Duarte) (Aegys Server Developer)
  Roniery Santos Cardoso (Aegys Developer)
  Alexandre Carlos Silva Abade (Aegys Developer)
  Mobius One (Aegys Developer)
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.ListBox, Winapi.Messages, uFormConexao, uLocaleFunctions,
  System.Actions, FMX.ActnList;

type
  TFormChat = class(TForm)
    Splitter1: TSplitter;
    Layout1: TLayout;
    lstMensagens: TListBox;
    Rectangle1: TRectangle;
    Rectangle8: TRectangle;
    mmMessage: TMemo;
    ActionList1: TActionList;
    actSendText: TAction;
    procedure mmMessageKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure actSendTextExecute(Sender: TObject);
  private
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
      message WM_GETMINMAXINFO;
  public
    procedure Mensagem(AMensagem: string; AAtendente: Boolean = True);
  end;

var
  FormChat: TFormChat;

implementation

{$R *.fmx}

uses uDM_Styles, uFrameMensagemChat, Winapi.Windows;

procedure TFormChat.Mensagem(AMensagem: string; AAtendente: Boolean);
var
  ItemAdd: TListBoxItem;
  ARec: TMensagemRec;
  FItem: TFrameMensagemChat;
begin
  lstMensagens.BeginUpdate;

  ARec.Texto := AMensagem;
  ARec.Atendente := AAtendente;
  ItemAdd := TListBoxItem.Create(nil);
  FItem := TFrameMensagemChat.Create(ItemAdd);
  FItem.Locale := TLocale.Create;
  FItem.Parent := ItemAdd;
  FItem.Mensagem := ARec;
  ItemAdd.Height := FItem.Tamanho;
  FItem.Align := TAlignLayout.Client;
  FItem.ListBox := lstMensagens;
  lstMensagens.AddObject(ItemAdd);

  lstMensagens.EndUpdate;
  lstMensagens.ItemIndex := lstMensagens.Items.Count-1;
end;

procedure TFormChat.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
var
  MinMaxInfo: PMinMaxInfo;
begin
  inherited;
  MinMaxInfo := Message.MinMaxInfo;
  MinMaxInfo^.ptMinTrackSize.X := 230; // Minimum Width
  MinMaxInfo^.ptMinTrackSize.Y := 340; // Minimum Height
end;

procedure TFormChat.actSendTextExecute(Sender: TObject);
begin
  if not mmMessage.Text.IsEmpty then
  begin
    Mensagem(mmMessage.Lines.Text, False);
    Conexao.SocketPrincipal.Socket.SendText('<|REDIRECT|><|CHAT|>' +
      mmMessage.Lines.Text + '<|END|>');
    mmMessage.Lines.Clear;
    lstMensagens.ScrollToItem(lstMensagens.ListItems
      [lstMensagens.Items.Count - 1]);
  end;
end;

procedure TFormChat.FormCreate(Sender: TObject);
begin
  // SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
  FormChat.Top := Trunc(Screen.WorkAreaHeight - FormChat.Height);
  FormChat.Left := Trunc(Screen.WorkAreaWidth - FormChat.Width);
end;

procedure TFormChat.mmMessageKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  // if Key = vkReturn then
  // begin
  // actSendText.Execute;
  // Key := vkNone;
  // end;
end;

end.