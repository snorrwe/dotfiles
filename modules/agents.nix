{
  username,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/agent/ 0755 ${username} agent-shared"
  ];
}
