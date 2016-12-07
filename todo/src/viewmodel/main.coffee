{ Model, attribute, from, List } = require('janus')
{ TodoLists, TodoListFetchRequest, TodoListSaveRequest } = require('../model/todo-list')


class Main extends Model
  # here we define a reference attribute, which can be resolved either by the
  # view layer or directly on the model with #resolve(key, app). in this case,
  # we want to reference the top-level application data we've stored away.
  #
  # we kick off the resolution of this reference in #_initialize below. see
  # src/model/todo-list to see where the request is declared and implemented.
  @attribute 'todoLists', class extends attribute.ReferenceAttribute
    @contains: TodoLists
    request: -> new TodoListFetchRequest()

  # the main interface element we need to render is the left sidebar that
  # allows selection of the todo list the user wants. this is easy: each todo
  # list is an enumerable option, and we wish to pick one.
  @attribute 'current', class extends attribute.EnumAttribute
    values: -> this.model.watch('todoLists')
    transient: true

  _initialize: ->
    # it's pretty typical in PageModels to have access to the app object and be
    # able to fire off requests from the Model object itself. this isn't
    # precisely a PageModel; it's a ViewModel. but that's really just because we
    # don't really have pages. so we'll resolve the todoLists reference:
    this.resolveNow('todoLists', this.get('app'))

    # if the page tries to unload, we'll want to save away the changes the user
    # has made:
    window.addEventListener('beforeunload', (event) => # jQuery recommends binding natively.
      # why not just call localStorage#setItem directly here? say we wanted to
      # use this one codebase to handle both electron- and browser-based versions
      # of our application. this separation of concerns allows that flexibility.
      this.get('app').getStore(new TodoListSaveRequest(this.get('todoLists'))).handle()

      # actually allow the unload now, per electron docs.
      undefined
    )


module.exports = { Main }

