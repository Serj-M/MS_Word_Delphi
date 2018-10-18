unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Function CreateWord:boolean;
Function VisibleWord(visible:boolean):boolean;
Function AddDoc:boolean;
Function SetTextToDoc(text_:string ;InsertAfter_:boolean):boolean;
Function SaveDocAs(file_:string):boolean;
Function CloseDoc:boolean;
Function CloseWord:boolean;
Function OpenDoc(file_:string):boolean;
Function StartOfDoc:boolean;
Function FindTextDoc(text_:string):boolean;
Function PasteTextDoc(text_:string):boolean;
Function FindAndPasteTextDoc(findtext_,pastetext_:string):boolean;

implementation

{$R *.dfm}

uses ComObj;
 var W:variant;

Function CreateWord:boolean;
begin
CreateWord:=true;
try
W:=CreateOleObject('Word.Application');
except
CreateWord:=false;
end;
End;

  

Function VisibleWord(visible:boolean):boolean;
begin
VisibleWord:=true;
try
W.visible:= visible;
except
VisibleWord:=false;
end;
End;


Function AddDoc:boolean;
 Var Doc_:variant;
begin
AddDoc:=true;
try
Doc_:=W.Documents;
Doc_.Add;
except
AddDoc:=false;
end;
End;



Function SetTextToDoc(text_:string ;InsertAfter_:boolean):boolean;
 var Rng_:variant;
begin
SetTextToDoc:=true;
try
Rng_:=W.ActiveDocument.Range;
if InsertAfter_ then Rng_.InsertAfter(text_) else Rng_.InsertBefore(text_);
except
SetTextToDoc:=false;
end;
End;



Function SaveDocAs(file_:string):boolean;
begin
SaveDocAs:=true;
try
W.ActiveDocument.SaveAs(file_);
except
SaveDocAs:=false;
end;
End;


Function CloseDoc:boolean;
begin
CloseDoc:=true;
try
W.ActiveDocument.Close;
except
CloseDoc:=false;
end;
End;


Function CloseWord:boolean;
begin
CloseWord:=true;
try
W.Quit;
except
CloseWord:=false;
end;
End;


Function OpenDoc(file_:string):boolean;
 Var Doc_:variant;
begin
OpenDoc:=true;
try
Doc_:=W.Documents;
Doc_.Open(file_);
except
OpenDoc:=false;
end;
End;


Function StartOfDoc:boolean;
begin
StartOfDoc:=true;
try
W.Selection.End:=0;
W.Selection.Start:=0;
except
StartOfDoc:=false;
end;
End;




Function FindTextDoc(text_:string):boolean;
begin
FindTextDoc:=true;
Try
W.Selection.Find.Forward:=true;
W.Selection.Find.Text:=text_;
FindTextDoc := W.Selection.Find.Execute;
except
FindTextDoc:=false;
end;
End;



Function PasteTextDoc(text_:string):boolean;
begin
PasteTextDoc:=true;
Try
W.Selection.Delete;
W.Selection.InsertAfter (text_);
except
PasteTextDoc:=false;
end;
End;


Function FindAndPasteTextDoc(findtext_,pastetext_:string):boolean;
begin
FindAndPasteTextDoc:=true;
try
W.Selection.Find.Forward:=true;
W.Selection.Find.Text:= findtext_;
if W.Selection.Find.Execute then begin
W.Selection.Delete;
W.Selection.InsertAfter (pastetext_);
end else FindAndPasteTextDoc:=false;
except
FindAndPasteTextDoc:=false;
end;
End;


Function PrintDialogWord:boolean;
 Const wdDialogFilePrint=88;
begin
PrintDialogWord:=true;
try
W.Dialogs.Item(wdDialogFilePrint).Show;
except
PrintDialogWord:=false;
end;
End;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if CreateWord
  then begin
   Messagebox(0,'Word запущен.','',0);
   VisibleWord(true);
   //Messagebox(0,'Word видим.','',0);
   //VisibleWord(false);
   //Messagebox(0,'Word невидим.','',0);
   //VisibleWord(true);
   //Messagebox(0,'Word видим.','',0);
   If AddDoc then begin
    Messagebox(0,'Документ создан.','',0);
    SetTextToDoc('Мой первый текст',true);
    Messagebox(0,'Добавлен текст','',0);
    SaveDocAs('c:\Мой первый текст');
    Messagebox(0,'Текст сохранен','',0);
    CloseDoc;
   end;
   Messagebox(0,' Текст закрыт','',0);
   CloseWord;
  end;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
 if CreateWord then begin
  VisibleWord(true);
  If OpenDoc('c:\Мой первый текст.doc') then begin
   messagebox(0,'Переходим к заполнению шаблона','Шаблон открыт',0);
   StartOfDoc; while not
    FindAndPasteTextDoc('Мой','Она ') do;
   StartOfDoc; while not
    FindAndPasteTextDoc('первый','работает ') do;
   StartOfDoc; while not
    FindAndPasteTextDoc('текст',' !!! ') do;
   SaveDocAs('c:\Мой првый текст 2.rtf');
   messagebox(0,'Переходим к печати документа',
    'Документ сформирован и сохранен',0);
   PrintDialogWord;
   CloseDoc;
  end;
  CloseWord;
 end;
end;


end.
