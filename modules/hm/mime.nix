{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
let
  thunderbird = "org.mozilla.Thunderbird.desktop";
  browser = "app.zen_browser.zen.desktop";
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = [ thunderbird ];
      "message/rfc822" = [ thunderbird ];
      "x-scheme-handler/mid" = [ thunderbird ];
      "x-scheme-handler/webcal" = [ thunderbird ];
      "text/calendar" = [ thunderbird ];
      "application/x-extension-ics" = [ thunderbird ];
      "x-scheme-handler/webcals" = [ thunderbird ];
      "x-scheme-handler/http" = [ browser ];
      "x-scheme-handler/https" = [ browser ];
      "x-scheme-handler/chrome" = [ browser ];
      "text/html" = [ browser ];
      "application/x-extension-htm" = [ browser ];
      "application/x-extension-html" = [ browser ];
      "application/x-extension-shtml" = [ browser ];
      "application/xhtml+xml" = [ browser ];
      "application/x-extension-xhtml" = [ browser ];
      "application/x-extension-xht" = [ browser ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "image/x-exr" = [ "org.kde.okteta.desktop" ];
      "x-scheme-handler/about" = [ browser ];
      "x-scheme-handler/unknown" = [ browser ];
      "application/pdf" = [ browser ];
      "x-scheme-handler/slack" = [ "com.slack.Slack.desktop" ];
    };
  };
}
