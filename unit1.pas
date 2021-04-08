unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLIntf,
  LCLType, LMessages, FileUtil, TAGraph, TASeries,TARadialSeries, TASources, ComCtrls, ExtCtrls, Spin;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    Chart1: TChart;
    Chart1PieSeries1: TPieSeries;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;

    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  PascalFiles: TStringList;  //для хранения имён файлов
  Sizes: array of Double;

implementation
uses TALegend, TAChartUtils;

{$R *.lfm}

{ TForm1 }



procedure TForm1.Button2Click(Sender: TObject);  //выбор каталога
var

  LazarusDirectory: string;  //для хранения имени папки
  i:integer;                 //для цикла
  ShortFileName:string;      //для короткого имени файла, без дирректорий
  FS: TFileStream;           //для файлового потока

  res:string;                //для отображения размеров файлов
  Result:Double;             //для пересчета размера файла
  edIzm:string;              //для отображения едениц измерения


begin
  setLength(Sizes,1);
  PascalFiles.Free;
  listbox1.Clear;            //в начале всё почистить
  listbox2.Clear;
  PascalFiles := TStringList.Create;                    //для хранения имен файлов
  if SelectDirectoryDialog1.Execute then                //диалог выбора папки
     begin
          Randomize;
          LazarusDirectory:=SelectDirectoryDialog1.FileName;   //получить назание выбранной папки
          label1.Caption:=SelectDirectoryDialog1.FileName;
          FindAllFiles(PascalFiles, LazarusDirectory, '*.*', false);    //получить все файлы
          //ShowMessage(Format('Found %d files', [PascalFiles.Count]));

          for i:=0 to PascalFiles.Count-1 do
              begin
                   FS:= TFileStream.Create(PascalFiles[i], fmOpenRead);       //открыть файловый поток на чтение
                   Result:=FS.Size;                                           //получить размер файла
                   setLength(Sizes,i+1);
                   Sizes[i]:=Result;
                   FS.free;
                   ShortFileName:=ExtractFileName(PascalFiles[i]);            //получить короткие имена

                   Chart1PieSeries1.AddPie(Result,ShortFileName,TColor(Random($FFFFFF))); //построение диаграммы
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
                   Listbox1.Items.Add(ShortFileName);                         //записать имена в listbox1
                   res :=Format('%.2n',[Result]);  //размер файла как десятичное число с 2-мя знаками после запятой
                   Listbox2.Items.Add(res+ ' ' + edIzm)                       //записать размер в listbox2
              end;

         //PascalFiles.Free;
     end;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin
(*
Chart1PieSeries1.Legend.Multiplicity:=lmPoint;
Chart1PieSeries1.Marks.Style:=smsLabel;
Chart1PieSeries1.AddPie(10,'part1',clPurple);
Chart1PieSeries1.AddPie(20,'part2',clRed);
*)
end;

procedure TForm1.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := Chart1PieSeries1.FindContainingSlice(Point(X,Y));
  label2.Caption:=inttostr(i);

end;

procedure TForm1.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: Integer;
  tmp: double;
begin
  i := Chart1PieSeries1.FindContainingSlice(Point(X,Y));

  if i>=0 then
  begin
       tmp:=Sizes[i]/1024/1024;
       label2.Caption:=PascalFiles[i] + ' ' + Format('%.2n',[tmp])+'Mb'; //добавить размер
  end;


end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     PascalFiles.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//Chart1PieSeries1.Legend.Multiplicity:=lmPoint;
//Chart1PieSeries1.Marks.Style:=smsLabel;
//Chart1PieSeries1.MarkPositions:=TPieMarkPositions(0);
end;

end.

