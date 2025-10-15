@echo off
echo Adicionando botao de atualizacao e atualizando versao...

:: Define a nova versao
set NEW_VERSION=2.2.3
set UPDATE_NUMBER=2

:: Atualiza o package.json
powershell -Command "(Get-Content package.json) -replace '\"version\": \"2.2.2\"', '\"version\": \"%NEW_VERSION%\"' | Set-Content package.json"
echo Versao no package.json atualizada para %NEW_VERSION%.

:: Adiciona o botao e o codigo no index.html
powershell -Command "(Get-Content index.html) -replace '</body>', '<div class=\"card\"><button id=\"updateButton\" class=\"app-button btn-primary\">Verificar Atualizacao</button></div></body>' | Set-Content index.html"
powershell -Command "(Get-Content index.html) -replace '</script>', 'document.getElementById(\"updateButton\").addEventListener(\"click\", () => { window.electronStore.get(\"lastUpdateCheck\").then(lastCheck => { if (!lastCheck || (Date.now() - lastCheck > 3600000)) { document.getElementById(\"updateButton\").textContent = \"Verificando...\"; window.electron.ipcRenderer.send(\"check-update\"); window.electronStore.set(\"lastUpdateCheck\", Date.now()); } else { alert(\"Ja verificado recentemente. Tente novamente em 1 hora.\"); } }); }); </script>' | Set-Content index.html"
echo Botao e codigo de atualizacao adicionados ao index.html.

:: Adiciona o codigo no main.js
powershell -Command "(Get-Content main.js) -replace 'function createWindow() {', 'const { ipcMain } = require(\"electron\"); function createWindow() {' | Set-Content main.js"
powershell -Command "(Get-Content main.js) -replace 'mainWindow.loadFile(\"index.html\");', 'mainWindow.loadFile(\"index.html\"); ipcMain.on(\"check-update\", (event) => { autoUpdater.checkForUpdatesAndNotify(); }); autoUpdater.on(\"update-downloaded\", (info) => { autoUpdater.quitAndInstall(); });' | Set-Content main.js"
echo Codigo de atualizacao adicionado ao main.js.

:: Adiciona, commita e push as mudancas
git add .
git commit -m "Atualizacao para v%NEW_VERSION% - Adicionado botao Verificar Atualizacao (Update %UPDATE_NUMBER%)"
git push

:: Cria e push a nova tag
git tag v%NEW_VERSION%
git push origin v%NEW_VERSION%

echo Processo concluido! Agora faca o build com 'npm run build' e suba o release no GitHub.
pause