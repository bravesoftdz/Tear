unit U01004;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UBase, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Actions, Vcl.ActnList, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Datasnap.Provider, Datasnap.DBClient, System.ImageList, Vcl.ImgList,
  Vcl.Grids, Vcl.DBGrids, DBGridBeleza, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TF01004 = class(TFBase)
    FDQuery1idtipo_recurso: TIntegerField;
    FDQuery1descricao: TStringField;
    ClientDataSet1idtipo_recurso: TIntegerField;
    ClientDataSet1descricao: TStringField;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Edit1: TEdit;
    Label3: TLabel;
    procedure acInserirExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure ClientDataSet1AfterInsert(DataSet: TDataSet);
    procedure acSalvarExecute(Sender: TObject);
    procedure acCancelarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure BExcluirClick(Sender: TObject);
    procedure BSalvarClick(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure BtnLimparFiltrosClick(Sender: TObject);
    procedure bRelatorioClick(Sender: TObject);
    procedure DSStateChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F01004: TF01004;

implementation

{$R *.dfm}

uses
uDataModule, u_relatorios;

procedure TF01004.acCancelarExecute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := clWindow;
end;

procedure TF01004.acEditarExecute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := CorCamposOnlyRead();
end;

procedure TF01004.acExcluirExecute(Sender: TObject);
begin
  {Contole de Exclus�o}
  DModule.qAux.Close;
  DModule.qAux.SQL.Text := 'select * from recurso rec where rec.idtiporecurso =:idTipoRecurso';
  DModule.qAux.ParamByName('idTipoRecurso').AsInteger:= (ClientDataSet1idtipo_recurso.AsInteger);
  DModule.qAux.Open;
  if(DModule.qAux.IsEmpty)then
  begin
    DModule.qAux.Close;
    DModule.qAux.SQL.Text := 'select * from cronometragem_has_tipo_recurso x where x.idtiporecurso =:idTipoRecurso';
    DModule.qAux.ParamByName('idTipoRecurso').AsInteger:= (ClientDataSet1idtipo_recurso.AsInteger);
    DModule.qAux.Open;
    if(DModule.qAux.IsEmpty)then
    begin
        inherited;
    end else
      ShowMessage('Operador habilitado a esse tipo de Recurso. N�o � poss�vel excluir.')
  end else
    ShowMessage('Recurso vinculado a este Tipo. N�o � poss�vel excluir.');

end;

procedure TF01004.acInserirExecute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := CorCamposOnlyRead();
end;

procedure TF01004.acSalvarExecute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := clWindow;
end;

procedure TF01004.Action5Execute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := clWindow;
end;

procedure TF01004.BExcluirClick(Sender: TObject);
begin
  //
  {Contole de Exclus�o}
  DModule.qAux.Close;
  DModule.qAux.SQL.Text := 'select * from recurso rec where rec.idtiporecurso =:idTipoRecurso';
  DModule.qAux.ParamByName('idTipoRecurso').AsInteger:= (ClientDataSet1idtipo_recurso.AsInteger);
  DModule.qAux.Open;
  if(DModule.qAux.IsEmpty)then
  begin
    DModule.qAux.Close;
    DModule.qAux.SQL.Text := 'select * from cronometragem_has_tipo_recurso x where x.idtiporecurso =:idTipoRecurso';
    DModule.qAux.ParamByName('idTipoRecurso').AsInteger:= (ClientDataSet1idtipo_recurso.AsInteger);
    DModule.qAux.Open;
    if(DModule.qAux.IsEmpty)then
    begin
        inherited;
    end else
      ShowMessage('Operador habilitado a esse tipo de Recurso. N�o � poss�vel excluir.')
  end else
    ShowMessage('Recurso vinculado a este Tipo. N�o � poss�vel excluir.');

end;

procedure TF01004.bRelatorioClick(Sender: TObject);
begin
  inherited;

  if NOT(Ds.DataSet.IsEmpty)then
  begin
      frelatorios := tfrelatorios.Create(self);
      with frelatorios do
      begin
          try
              visible := false;
              Assimila_Relat_q(Screen.ActiveForm.Name, 0, DS.DataSet, nil, 'idTipo_Recurso', '');
              ShowModal;
          finally
              Relatorios_sis.close;
              relats_usur.close;
              Free;
          end;
      end;
  end else
  begin
    ShowMessage('Relat�rio necessita de pesquisa');
  end;
end;

procedure TF01004.BSalvarClick(Sender: TObject);
begin
  if trim(DBEdit2.Text) <> '' then
    begin
      inherited;
      DBEdit1.Color := clWindow;
    end else
      begin
       showmessage('Preencha o Campo Descri��o');
       DBEdit2.SetFocus;
      end;


end;

procedure TF01004.btnFiltrarClick(Sender: TObject);
begin
  inherited;
  FDQuery1.Close;
  FDQuery1.SQL.Text := 'select * from tipo_recurso where descricao like "%' + Edit1.Text +'%"';
  FDQuery1.Open;
  BPesquisar.Click;
end;

procedure TF01004.BtnLimparFiltrosClick(Sender: TObject);
begin
  inherited;
  FDQuery1.Close;
  FDQuery1.SQL.Text := 'select * from tipo_recurso';
  FDQuery1.Open;
  BPesquisar.Click;
end;

procedure TF01004.ClientDataSet1AfterInsert(DataSet: TDataSet);
begin
  inherited;
  ClientDataSet1idtipo_recurso.AsInteger := DModule.buscaProximoParametro('seqTipoRecurso');

end;

procedure TF01004.DSStateChange(Sender: TObject);
begin
  inherited;
  if (ds.DataSet.State = dsInsert) then
  begin
    DBEdit1.Color := CorCamposOnlyRead();
  end;
  if (ds.DataSet.State = dsEdit) then
  begin
    DBEdit1.Color := CorCamposOnlyRead();
  end;
end;

Initialization
  RegisterClass(TF01004);
Finalization
  UnRegisterClass(TF01004);
end.
