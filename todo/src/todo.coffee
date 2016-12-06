# drop $ on the window so the stdlib picks it up (TODO: feels ugly).
$ = require('jquery')
window.jQuery = window.$ = $

{ App, Library } = require('janus').application
stdlib = require('janus-stdlib')

{ Main } = require('./viewmodel/main')

# set up our view and store libraries.
views = new Library()
stdlib.view.registerWith(views)
require('./view/main').registerWith(views)
require('./view/todo-list').registerWith(views)
require('./view/todo').registerWith(views)
require('./view/subtodo').registerWith(views)

# set up our app, which will be passed down through all views.
app = new App({ views })

$ -> # wait for doc ready, then:
  # initialize our Main object, which is a Model we've implemented in
  # src/model/main. we then get a view for it from our app (not the view library
  # directly; this way app is plumbed through). then drop it on the page.
  main = new Main()
  mainView = app.getView(main)
  $('#janus').append(mainView.artifact())
  mainView.wireEvents()

