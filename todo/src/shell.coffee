{ app, BrowserWindow } = require('electron')

app.on('ready', ->
  hWnd = new BrowserWindow( width: 650, height: 480 )

  hWnd.on('closed', -> hWnd = null)
  hWnd.on('window-all-closed', -> app.quit())
)

