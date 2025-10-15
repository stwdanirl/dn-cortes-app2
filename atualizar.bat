@echo off
echo Atualizando o NidusCut para uma nova versão...

:: Define a nova versão (você pode mudar manualmente aqui)
set NEW_VERSION=2.2.1

:: Atualiza o package.json
powershell -Command "(Get-Content package.json) -replace '\"version\": \"2.2.0\"', '\"version\": \"%NEW_VERSION%\"' | Set-Content package.json"
echo Versao no package.json atualizada para %NEW_VERSION%.

:: Atualiza o index.html (adiciona a versao no titulo)
powershell -Command "(Get-Content index.html) -replace '<title>NidusCut - Otimizador de Cortes</title>', '<title>NidusCut v%NEW_VERSION% - Otimizador de Cortes</title>' | Set-Content index.html"
echo Titulo no index.html atualizado para v%NEW_VERSION%.

:: Adiciona, commita e push as mudancas
git add .
git commit -m "Atualizacao para v%NEW_VERSION% - nova versao"
git push

:: Cria e push a nova tag
git tag v%NEW_VERSION%
git push origin v%NEW_VERSION%

echo Processo concluido! Agora faca o build (npm run build) e suba o release no GitHub.
pause