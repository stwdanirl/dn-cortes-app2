@echo off
echo Atualizando o NidusCut com novo numero de update...

:: Define a nova versão e numero de update
set NEW_VERSION=2.2.2
set UPDATE_NUMBER=1

:: Atualiza o package.json
powershell -Command "(Get-Content package.json) -replace '\"version\": \"2.2.1\"', '\"version\": \"%NEW_VERSION%\"' | Set-Content package.json"
echo Versao no package.json atualizada para %NEW_VERSION%.

:: Adiciona o numero de update no index.html (em um canto discreto, inferior direito)
powershell -Command "(Get-Content index.html) -replace '</body>', '<div style=\"position: fixed; bottom: 5px; right: 5px; font-size: 10px; color: #888;\">Update %UPDATE_NUMBER%</div></body>' | Set-Content index.html"
echo Numero de update %UPDATE_NUMBER% adicionado no canto inferior direito.

:: Adiciona, commita e push as mudancas
git add .
git commit -m "Atualizacao para v%NEW_VERSION% - Adicionado numero de update %UPDATE_NUMBER%"
git push

:: Cria e push a nova tag
git tag v%NEW_VERSION%
git push origin v%NEW_VERSION%

echo Processo concluido! Agora faca o build (npm run build) e suba o release no GitHub.
pause