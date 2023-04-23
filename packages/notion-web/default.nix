# Dependências desse pacote
{
  lib,
  chromium,
  stdenv,
  writeScript,
  makeDesktopItem,
  fetchurl,
}:

stdenv.mkDerivation {
  # Nome e versão do pacote
  pname = "notion-web";
  version = "0.1";

  # "Fonte" principal
  # No caso vai ser um script que criamos aqui mesmo
  src = writeScript "notion" ''
    # O lib.getExe é um jeito mais clean de colocar o /bin/nome
    ${lib.getExe chromium} --app=https://notion.so
  '';
  dontUnpack = true; # Não tratar src como um tgz/zip, q é o comportamento padrão

  # Pegar um ícone da internet
  icon = fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/e/e9/Notion-logo.svg";
    hash = "sha256-G1KhhdgWbZM59cFt1ReJ7jD0mmW01Ac4KQtgQj4zEWA=";
  };

  # Criar .desktop
  desktopItem = makeDesktopItem {
    name = "notion"; # Nome do arquivo
    desktopName = "Notion"; # Nome que aparece no menu
    exec = "notion"; # Comando para executar
    icon = "notion"; # Nome do ícone (minus extensão)
    startupWMClass = "chrome-notion.so__-Default"; # O chrome seta essa classe quando usamos --app
  };

  # Fase de instalação
  installPhase = ''
    # Copiar script para o lugar certo
    install -Dm755 $src $out/bin/notion

    # Copiar .desktop para o lugar certo
    install -Dm644 $desktopItem/share/applications/notion.desktop $out/share/applications/notion.desktop

    # Copiar ícone para o lugar certo
    install -Dm644 $icon $out/share/pixmaps/notion.svg
  '';

  # Meta-informações do pacote
  meta = {
    description = "A productivity and note-taking web app.";
    mainProgram = "notion"; # O pacote chama "notion-web", mas o binário chama "notion"
    platforms = lib.platforms.all;
  };
}
