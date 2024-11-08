program UpdateAnimal;

uses
  System.StartUpCopy,
  FMX.Forms,
  UUpdateAnimal in 'UUpdateAnimal.pas' {Update};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUpdate, Update);
  Application.Run;

end.
