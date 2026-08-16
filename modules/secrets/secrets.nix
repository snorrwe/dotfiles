let
  home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIyVx2NlhEycZ4RIRVf5I8YnfIMxxbBXnWhlQTOr2wJ7";
  danipc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZeVRsak3U6cP43KolnIauGKQtL71XZbTYx4vT3AzZ+ snorrwe@danipc";
  daniframe = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmU7ffXagNUVl43rOHAj9aQg39UjKy6dPMoMyJpypIb snorrwe@daniframe";

  users = [
    danipc
    daniframe
    home
  ];

in
{
  "s3.local.json".publicKeys = users;
}
