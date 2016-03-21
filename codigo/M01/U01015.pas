unit U01015;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.FileCtrl, system.JSON, Data.DB, Vcl.Grids, Vcl.DBGrids, DBGridBeleza,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Datasnap.DBClient, Datasnap.Provider,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons;

type
  TF01015 = class(TForm)
    Panel1: TPanel;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    ListView1: TListView;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    matriz: array of array of integer;
    ParIdProduto : integer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; pPROD: integer);

  end;

var
  F01015: TF01015;

implementation

{$R *.dfm}

uses UPrincipal, udATAMODULE, IOUtils,DBXJSONReflect, DBXJSON, Generics.Collections;

procedure TF01015.BitBtn1Click(Sender: TObject);
var
idOperacao, idOperador, idCronometrista, idTecido, idRecurso, I, prioridade: Integer;
dataCronometragem : TDate;
QAux2 : TFDQuery;
begin
//
  QAux2.Connection := DModule.FDConnection;

  if ListView1.Selected <> nil then
  BEGIN
    //Obten��o dos valores na listview
     idOperacao := strtoint(ListView1.Items[ListView1.Selected.Index].Caption);
     idOperador := strtoint(ListView1.Items[ListView1.Selected.Index].SubItems[0]);
     idCronometrista := strtoint(ListView1.Items[ListView1.Selected.Index].SubItems[1]);
     idTecido := strtoint(ListView1.Items[ListView1.Selected.Index].SubItems[2]);
     idRecurso := strtoint(ListView1.Items[ListView1.Selected.Index].SubItems[3]);
     dataCronometragem := StrToDate(ListView1.Items[ListView1.Selected.Index].SubItems[4]);

     //Verifica se j� tem cronometragem dessa opera��o
     DModule.qAux.Close;
     DModule.qAux.SQL.Text := 'select * from cronometragem where idProduto =:idProd and idOperacao =:idOp';
     DModule.qAux.ParamByName('idProd').AsInteger:= (ParIdProduto);
     DModule.qAux.ParamByName('idOp').AsInteger:= (idOperacao);
     DModule.qAux.Open;
     DModule.qAux.first;
     if(DModule.qAux.IsEmpty)then
     begin
        ShowMessage('Opera��o:' + inttostr(idOperacao) +#13+
                'Operador:' + inttostr(idOperador) +#13+
                'Cronometrista:' + inttostr(idCronometrista) +#13+
                'Tecido:' + inttostr(idTecido) +#13+
                'Recurso:' + inttostr(idRecurso) +#13+
                'Data:' + DateToStr(dataCronometragem)
        );

        //Prioridade
       qAux2.Close;
       qAux2.SQL.Text := 'select count(*) as conta from cronometragem where idProduto =:idProd';
       qAux2.ParamByName('idProd').AsInteger:=  ParIdProduto;
       DModule.qAux.Open;
       prioridade := qAux2.FieldByName('minutos').AsInteger + 1;
       qAux2.Close;

       DModule.qAux.Close;
       DModule.qAux.SQL.Text := 'INSERT INTO CRONOMETRAGEM(idCronometragem, tempo_original, tempo_ideal,ritmo, num_pecas,tolerancia,comprimento_prod,num_ocorrencia,idProduto,idCronometrista, idTecido, idOperacao,idOperador,prioridade, dataCronometragem)' +
          'VALUES(:idCronometragem, :tempo_original, :tempo_ideal,:ritmo,:num_pecas,:tolerancia,:comprimento_prod,:num_ocorrencia,:idProduto, ' +
          ':idCronometrista, :idTecido, :idOperacao,:idOperador,:prioridade, :dataCronometragem)';

       DModule.qAux.ParamByName('idCronometragem').AsInteger:= DModule.buscaProximoParametro('seqCronometragem');
       DModule.qAux.ParamByName('tempo_original').AsBoolean:= false;
       DModule.qAux.ParamByName('tempo_ideal').AsBoolean:= false;
       DModule.qAux.ParamByName('idProduto').AsInteger:= ParIdProduto;
       DModule.qAux.ParamByName('idCronometrista').AsInteger:= idCronometrista;
       DModule.qAux.ParamByName('idTecido').AsInteger:= idTecido;
       DModule.qAux.ParamByName('idOperacao').AsInteger:= idOperacao;
       DModule.qAux.ParamByName('idOperador').AsInteger:= idOperador;
       DModule.qAux.ParamByName('dataCronometragem').AsDate:= dataCronometragem;
       DModule.qAux.ParamByName(':prioridade').AsInteger:= prioridade;

       //Rever esses dados vindos do APP
       DModule.qAux.ParamByName(':ritmo').AsInteger:= 80;
       DModule.qAux.ParamByName(':num_pecas').AsInteger:= 1;
       DModule.qAux.ParamByName(':tolerancia').AsInteger:= 15;
       DModule.qAux.ParamByName(':comprimento_prod').AsInteger:= 35;
       DModule.qAux.ParamByName(':num_ocorrencia').AsInteger:= 1;

       DModule.qAux.ExecSQL;

        //Obten��o dos tempos na matriz
        for I := 0 to (Length(matriz[ListView1.Selected.Index]) -1) do
        begin
          ShowMessage(inttostr(matriz[ListView1.Selected.Index][I]));
        end;


     end else
      ShowMessage('Cronometragem j� existente.');

  END else
    ShowMessage('Selecione uma cronometragem.');
end;

constructor TF01015.Create(AOwner: TComponent; pPROD: integer);
begin
  //
  inherited Create(AOwner);
  ParIdProduto := pPROD;
end;

procedure TF01015.FileListBox1DblClick(Sender: TObject);
var
LI: TListItem;
arqCompleto, jSubObj: TJSONObject;
jp: TJSONPair;  //
jArrayCronometragem, jarrayTempo : TJSONArray;
i,j,r: integer;
begin
    TRY
      //Propriedade para selecionar a linha toda
      ListView1.RowSelect := true;

      //Limpa ListView
      ListView1.Clear;

      //Lendo arquivo json
      arqCompleto := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(TFile.ReadAllText(FileListBox1.FileName)), 0) as TJSONObject;

      //percorre o arquivo
      for i := 0 to arqCompleto.Size - 1 do
      begin
          //obt�m tag i (Exemplo: tag "Dados" do arquivo)
          jp := arqCompleto.Get(i);

          //Pega lista de cronometragens
          jArrayCronometragem := TJSONArray.Create;
          jArrayCronometragem := (jp.JsonValue as TJSONArray);
          jSubObj:= TJSONObject.Create;

          //Tamanho Matriz Vertical
          matriz := nil;
          SetLength(matriz,jArrayCronometragem.Size);

          //Percorre cada cronometragem
          for j := 0 to jArrayCronometragem.Size -1 do
          begin
              jSubObj := (jArrayCronometragem.Get(j) as TJSONObject);
              try
                  LI := ListView1.Items.Add;
                  //Operacao
                  li.Caption := ((jSubObj.GetValue('operacao').Value)); //
                  //Operador
                  LI.SubItems.Add((jSubObj.GetValue('operador').Value));;
                  //Cronometrista
                  LI.SubItems.Add((jSubObj.GetValue('cronometrista').Value));;
                  //Tecido
                  LI.SubItems.Add(jSubObj.GetValue('tecido').Value);;
                  //Recurso
                  LI.SubItems.Add((jSubObj.GetValue('recurso').Value));;
                  //Data
                  LI.SubItems.Add((jSubObj.GetValue('data').Value));;

                  {ShowMessage(
                  jSubObj.Get(0).JsonString.Value + ': ' + jSubObj.Get(0).JsonValue.Value + #13 +
                  jSubObj.Get(1).JsonString.Value + ': ' + jSubObj.Get(1).JsonValue.Value + #13 +
                  jSubObj.Get(2).JsonString.Value + ': ' + jSubObj.Get(2).JsonValue.Value + #13 +
                  jSubObj.Get(3).JsonString.Value + ': ' + jSubObj.Get(3).JsonValue.Value + #13 +
                  jSubObj.Get(4).JsonString.Value + ': ' + jSubObj.Get(4).JsonValue.Value + #13 +
                  jSubObj.Get(5).JsonString.Value + ': ' + jSubObj.Get(5).JsonValue.Value + #13 +
                  jSubObj.Get(6).JsonString.Value + ': ' + jSubObj.Get(6).JsonValue.Value + #13
                  );}


                  //Pega o array "TEMPO"
                  jArrayTempo := TJSONArray.Create;
                  jArrayTempo := (jSubObj.Get(5).JsonValue as TJSONArray);

                  //Tamanho da matriz horizontal
                  SetLength(matriz[j], jArrayTempo.Size);

                  //percorre cada elemento
                  for r := 0 to jArrayTempo.Size -1 do
                  begin
                      //ShowMessage(jArrayTempo.Get(r).Value);
                      matriz[j][r] := strtoint(jArrayTempo.Get(r).Value);
                  end;

              finally
              begin
                //desaloca memoria
                li := nil;
                li.Free;
              end;
          end;

        end;

      end;
    FINALLY
      arqCompleto.Free;
      //ShowMessage('OK');

    END;
end;

procedure TF01015.FormShow(Sender: TObject);
begin
  DirectoryListBox1.Directory := ExtractFilePath(Application.ExeName) + 'APPCronometragens';
end;

Initialization
  RegisterClass(TF01015);
Finalization
  UnRegisterClass(TF01015);
end.
