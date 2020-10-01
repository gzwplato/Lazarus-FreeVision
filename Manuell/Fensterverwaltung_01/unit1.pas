unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMButton, WMWindow, WMDialog, WMDesktop, WMApplication;

type

  { TMyToolBar }

  TMyToolBar = class(TToolBar)
  private
    BtnClose: TButton;
    btnQuit: TButton;
  public
    constructor Create; override;
  end;

  { TMyDialog }

  TMyDialog = class(TDialog)
  private
    btnClose, btnQuit, btn0, btn1, btn2: TButton;
  public
    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;

  { TMyApp }

  TMyApp = class(TApplication)
  private
    MyToolBar: TMyToolBar;
  public
    constructor Create; override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Buttonup: StdCtrls.TButton;
    Buttonminus: StdCtrls.TButton;
    Buttonleft: StdCtrls.TButton;
    Buttonright: StdCtrls.TButton;
    Buttonplus: StdCtrls.TButton;
    Buttondown: StdCtrls.TButton;
    Panel1: TPanel;
    procedure ButtonminusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; WMButton: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  private
    App: TMyApp;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  cmBtn0 = 1000;
  cmBtn1 = 1001;
  cmBtn2 = 1002;

{ TMyApp }

constructor TMyApp.Create;
begin
  inherited Create;
  MyToolBar := TMyToolBar.Create;
  Insert(MyToolBar);
end;

{ TMyToolBar }

constructor TMyToolBar.Create;
begin
  inherited Create;
  btnClose := TButton.Create;
  btnClose.Top := BorderSize;
  btnClose.Left := BorderSize;
  btnClose.Caption := 'Close';
  btnClose.Command := cmClose;
  Insert(btnClose);

  btnQuit := TButton.Create;
  btnQuit.Top := BorderSize;
  btnQuit.Left := btnQuit.Width + BorderSize * 2;
  btnQuit.Caption := 'Quit';
  btnQuit.Command := cmQuit;
  Insert(btnQuit);
end;

{ TMyDialog }

constructor TMyDialog.Create;
begin
  inherited Create;

  Left := 100;
  Top := 100;
  Width := 500;
  Height := 200;
  Caption := 'Mein Dialog';

  btn0 := TButton.Create;
  btn0.Anchors := [akRight, akBottom];
  btn0.Top := Client.Height - btn0.Height - 10;
  btn0.Left := Client.Width - (btn0.Width + 10) * 5;
  btn0.Caption := 'btn0';
  btn0.Command := cmBtn0;
  Client.Insert(btn0);

  btn1 := TButton.Create;
  btn1.Anchors := [akRight, akBottom];
  btn1.Top := Client.Height - btn1.Height - 10;
  btn1.Left := Client.Width - (btn0.Width + 10) * 4;
  btn1.Caption := 'btn1';
  btn1.Command := cmBtn1;
  Client.Insert(btn1);

  btn2 := TButton.Create;
  btn2.Anchors := [akRight, akBottom];
  btn2.Top := Client.Height - btn2.Height - 10;
  btn2.Left := Client.Width - (btn0.Width + 10) * 3;
  btn2.Caption := 'btn2';
  btn2.Command := cmBtn2;
  Client.Insert(btn2);

  btnClose := TButton.Create;
  btnClose.Anchors := [akRight, akBottom];
  btnClose.Top := Client.Height - btnClose.Height - 10;
  btnClose.Left := Client.Width - (btn0.Width + 10) * 2;
  btnClose.Caption := 'Close';
  btnClose.Command := cmClose;
  Client.Insert(btnClose);

  btnQuit := TButton.Create;
  btnQuit.Anchors := [akRight, akBottom];
  btnQuit.Top := Client.Height - btnQuit.Height - 10;
  btnQuit.Left := Client.Width - btn0.Width - 10;
  btnQuit.Caption := 'Quit';
  btnQuit.Command := cmQuit;
  Client.Insert(btnQuit);
end;

procedure TMyDialog.EventHandle(Event: TEvent);
begin
  if Event.What = whcmCommand then begin
    case Event.Value0 of
      cmBtn0: begin
        WriteLn('Button 0 gedrückt');
      end;
      cmBtn1: begin
        WriteLn('Button 1 gedrückt');
      end;
      cmBtn2: begin
        WriteLn('Button 2 gedrückt');
      end else begin
        //         if Parent<>nil;
      end;
    end;
  end;

  inherited EventHandle(Event);
end;

{ TForm1 }

procedure TForm1.ButtonminusClick(Sender: TObject);
var
  v: TView;
begin
  //if TButton(Sender).Name = 'Buttonplus' then begin
  //  v := TView.Create;
  //  v.Assign(Random(Width), Random(Height), Random(Width), Random(Height));
  //  v.Color := Random($FFFFFF);
  //  v.Caption := IntToStr(Length(Views));
  //  Insert(v, Views, 0);
  //end;
  //
  //if Length(Views) > 0 then begin
  //  case TButton(Sender).Name of
  //    'Buttonminus': begin
  //      Views[0].Free;
  //      Delete(Views, 0, 1);
  //    end;
  //    'Buttonleft': begin
  //      Views[0].Move(-8, 0);
  //    end;
  //    'Buttonright': begin
  //      Views[0].Move(8, 0);
  //    end;
  //    'Buttonup': begin
  //      Views[0].Move(0, -8);
  //    end;
  //    'Buttondown': begin
  //      Views[0].Move(0, 8);
  //    end;
  //  end;
  //  Repaint;
  //end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
  win: TWindow;
  Dialog: TMyDialog;
begin
  Panel1.DoubleBuffered := True;
  Randomize;

  App := TMyApp.Create;
  App.Width := Panel1.Width;
  App.Height := Panel1.Height;
  App.Caption := 'Application';


  for i := 0 to 19 do begin
    win := TWindow.Create;
    with Panel1 do begin
      win.Left := Random(App.Width * 2 div 3);
      win.Top := Random(App.Height * 2 div 3);
      win.Width := Random(App.Width div 3) + 100;
      win.Height := Random(App.Height div 3) + 100;
    end;
    win.Caption := 'Fenster: ' + IntToStr(i);
    App.Desktop.Insert(win);
  end;

  Dialog := TMyDialog.Create;
  App.Desktop.Insert(Dialog);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  App.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
  ev: TEvent;
begin
  ev.What := WMView.whRepaint;
  App.EventHandle(ev);

  //  for i := 1 to 10 do begin
  //    Panel1.Canvas.Line(i * 100, 0, i * 100, Panel1.Height);
  //  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  App.Width := Panel1.Width;
  App.Height := Panel1.Height;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; WMButton: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if ssLeft in Shift then begin
    App.EventHandle(getMouseCommand(WMView.MouseDown, x, y));
  end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  //  if ssLeft in Shift then begin
  App.EventHandle(getMouseCommand(WMView.MouseUp, x, y));
  //  end;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  if ssLeft in Shift then begin
    App.EventHandle(getMouseCommand(WMView.MouseMove, x, y));
  end;
end;

end.
