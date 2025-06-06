unit FNMatrixMainForm;

interface

uses
    Contnrs, SysUtils, StrUtils, Classes, SyncObjs, Forms, ExtCtrls, Windows, Messages,
    MXBlock;

type
    CFNMatrixMainForm = class(TForm)
    protected


    public
        constructor Create(AOwner:TComponent); override;
        destructor Destroy; override;

    private

    end;

implementation
uses
    FNSocketManager, FNGlobal, FNCommonVariable;

/////////////////////////////////////////////////////////////////////////////
//CFNMatrixMainForm
//---------------------------------------------------------------------------
constructor CFNMatrixMainForm.Create(AOwner:TComponent);
begin
    inherited Create(AOwner);


end;

//---------------------------------------------------------------------------
destructor CFNMatrixMainForm.Destroy;
begin

    inherited Destroy;
end;

end.
