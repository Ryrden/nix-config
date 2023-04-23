{
  lib,
  chromium,
  stdenv,
  writeScript,
  makeDesktopItem,
  copyDesktopItems,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "notion";
  version = "0.1";

  nativeBuildInputs = [ copyDesktopItems ];

  src = writeScript "notion" ''
    ${lib.getExe chromium} --app=https://notion.so
  '';
  dontUnpack = true;

  icon = fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/e/e9/Notion-logo.svg";
    hash = "sha256-G1KhhdgWbZM59cFt1ReJ7jD0mmW01Ac4KQtgQj4zEWA=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "notion";
      desktopName = "Notion";
      exec = "notion";
      icon = "notion";
    })
  ];

  postInstall = ''
    install -Dm755 $src $out/bin/notion
    install -Dm644 $icon $out/share/pixmaps/notion.svg
  '';

  meta = with lib; {
    description = "A productivity and note-taking web app.";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
