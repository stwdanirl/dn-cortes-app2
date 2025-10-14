const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const Store = require('electron-store');
const { autoUpdater } = require('electron-updater');

const store = new Store();

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  mainWindow.loadFile('index.html');
  // mainWindow.webContents.openDevTools(); // Descomente para depurar
}

app.whenReady().then(() => {
  // IPC para interagir com o electron-store (licença, etc.)
  ipcMain.handle('electron-store-get', (event, key) => store.get(key));
  ipcMain.handle('electron-store-set', (event, key, value) => store.set(key, value));
  ipcMain.handle('electron-store-delete', (event, key) => store.delete(key));

  createWindow();

  // Procura por atualizações assim que o app estiver pronto
  autoUpdater.checkForUpdatesAndNotify();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

