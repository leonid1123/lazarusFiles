unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLIntf, LCLType, LMessages, Windows, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  FS: TFileStream;
  Filename:string;
  Result:Double;
  edIzm:string;

begin


  if OpenDialog1.Execute then
     begin
          Filename := OpenDialog1.Filename;
     end;



  FS := TFileStream.Create(Filename, fmOpenRead);
  Result:=FS.Size;
  if ((Result>0) and (Result<=999999)) then
     begin
          Result:=Result/1024;//пересчитать в Кб
          edIzm:= 'Кб';
     end;
  if ((Result>1000000) and (Result<=9999999)) then
     Begin
          Result:=Result/1024/1024;//пересчитать в Мб
          edIzm:= 'Мб';
     end;
  if (Result>10000000) then
     Begin
          Result:=Result/1024/1024/1024;//пересчитать в Гб
          edIzm:= 'Гб';
     end;
  listbox1.Items.Add(FS.FileName + ' ' + FormatFloat('######.0',Result)+' '+edIzm);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  PascalFiles: TStringList;
  LazarusDirectory: string;
begin
  //comment
  PascalFiles := TStringList.Create;
      if SelectDirectoryDialog1.Execute then
     begin
          LazarusDirectory:=SelectDirectoryDialog1.FileName;
          FindAllFiles(PascalFiles, LazarusDirectory, '*.*', false);
          ShowMessage(Format('Found %d files', [PascalFiles.Count]));
          PascalFiles.Free;
     end;
end;

end.

