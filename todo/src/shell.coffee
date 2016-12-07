{ app, BrowserWindow } = require('electron')
path = require('path')
url = require('url')

hWnd = null # hold a reference open.
app.on('ready', ->
  hWnd = new BrowserWindow( width: 650, minWidth: 650, height: 480, minHeight: 480 )

  hWnd.loadURL(url.format({ pathname: path.join(__dirname, 'app.html'), protocol: 'file:', slashes: true }))

  hWnd.on('closed', -> hWnd = null)
  hWnd.on('window-all-closed', -> app.quit())
)

