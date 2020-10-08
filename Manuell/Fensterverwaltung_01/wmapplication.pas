unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  WMView, WMDesktop, WMButton, WMMenu;

type

  { TToolBar }

  TToolBar = class(TView)
    constructor Create; override;
    procedure AddButton(const ACaption: string; ACommand: integer);
  end;

{ TApplication }

type
  TApplication = class(TView)
  private
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;
    MenuBar: TMenuBar;
    MenuBox: array of TMenuBox;
    constructor Create; override;
    procedure EventHandle(var Event: TEvent); override;
  end;

implementation

uses
  Unit1;  //????????????????????????????????????????????'''''

const
  rand = 40;

{ TToolBar }

constructor TToolBar.Create;
begin
  inherited Create;
  Color := clGray;
  Top := rand;
  Height := rand;
  Anchors := [akLeft, akRight, akTop];
  Caption := 'ToolBar';
end;

procedure TToolBar.AddButton(const ACaption: string; ACommand: integer);
var
  btn: TButton;
begin
  btn := TButton.Create;
  btn.Top := BorderSize;
  btn.Left := Length(View) * 80 + BorderSize;
  btn.Caption := ACaption;
  btn.Command := ACommand;
  Insert(btn);
end;


{ TApplication }

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Desktop := TDesktop.Create;
  Desktop.Top := rand * 2;
  Desktop.Height := Height - 2 * rand;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  Insert(Desktop);

  MenuBar := TMenuBar.Create;
  //  MenuBar.Left := 50;
  //  MenuBar.Top := 5;
  Insert(MenuBar);

  ToolBar := TToolBar.Create;
  ToolBar.Top := MenuBar.Height;
  Insert(ToolBar);
end;

procedure TApplication.EventHandle(var Event: TEvent);
var
  ev: TEvent;
  mItem: TMenuItems;
  i, l: integer;
  menu: TMenu;
  ClickInMenu: boolean;
begin
  case Event.What of
    whMouse: begin
      if Event.MouseCommand = MouseDown then begin
        ClickInMenu := False;

        for i := TMenuBox.MenuCounter - 2 downto 0 do begin
          if MenuBox[i].IsMousInView(Event.x, Event.y) then begin
            ClickInMenu := True;
            Break;
          end;
        end;

        if not ClickInMenu then begin
          for i := TMenuBox.MenuCounter - 2 downto 0 do begin
            Delete(MenuBox[i]);
          end;
          SetLength(MenuBox, 0);

          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whcmCommand: begin
      case Event.Command of
        cmQuit: begin
          Form1.Close;
        end;
        cmClose: begin
          Desktop.Delete(0);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whMenuCommand: begin
      if Event.Index >= 0 then begin
        menu := TMenu(Event.Sender);
        mItem := menu.MenuItem.Items[Event.Index];
        if Length(mItem.Items) > 0 then begin  // Ist SubMenu Link ?
          for i := TMenuBox.MenuCounter - 2 downto menu.Index - 1 do begin
            Delete(MenuBox[i]);
            l := Length(MenuBox);
            SetLength(MenuBox, l - 1);
          end;

          l := Length(MenuBox);
          SetLength(MenuBox, l + 1);
          MenuBox[l] := TMenuBox.Create;
          MenuBox[l].MenuItem := mItem;
          MenuBox[l].Left := Event.Left;
          MenuBox[l].Top := Event.Top;
          Insert(MenuBox[l]);
        end else begin
          ev.What := whcmCommand;
          ev.Command := mItem.Command;
          EventHandle(ev);
          for i := TMenuBox.MenuCounter - 2 downto 0 do begin
            Delete(MenuBox[i]);
          end;
          SetLength(MenuBox, 0);
        end;

        ev.What := whRepaint;
        EventHandle(ev);
      end;
    end;
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Canvas);
    end;
    else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
