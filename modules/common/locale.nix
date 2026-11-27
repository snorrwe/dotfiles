{
  flake.modules.nixos.common = _: {
    time.timeZone = "Europe/Budapest";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
