{
  ...
}:
let
  email_client = "eu.betterbird.Betterbird";
  browser = "app.zen_browser.zen.desktop";
in
{

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = [ email_client ];
      "message/rfc822" = [ email_client ];
      "x-scheme-handler/mid" = [ email_client ];
      "x-scheme-handler/webcal" = [ email_client ];
      "text/calendar" = [ email_client ];
      "application/x-extension-ics" = [ email_client ];
      "x-scheme-handler/webcals" = [ email_client ];
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
    };
  };
}
