{ Model, attribute, List, types } = require('janus')
{ Store, Request } = require('janus').store
{ Todos } = require('./todo')


TodoList = Model.build(
  attribute('name', attribute.Text)

  attribute 'todos', class extends attribute.Collection.of(Todos)
    default: -> new Todos()
)
TodoLists = List.of(TodoList)


# normally, there'd be more to this class. parameters for which ID to fetch, or
# cache-key computation, or any number of other things relevant to the context
# of a request. but because we literally just have one piece of data that's
# nearly infinitely cheap to fetch, all this class really does is serve as a
# token to be instantiated and passed around.
class TodoListFetchRequest extends Request

class TodoListFetchStore extends Store
  _handle: ->
    stored = localStorage.getItem('todo')
    this.request.set(types.result.success(if stored? then JSON.parse(stored) else []))
    types.handling.handled()


# similarly, here is a request to save. it's not atypical to simply let the
# Request superclass's general @options intake handle all the parameters we
# might need, but here we make it explicit just to show how you can.
class TodoListSaveRequest extends Request
  constructor: (@todoLists) -> super()
  type: types.operation.update()

class TodoListSaveStore extends Store
  _handle: ->
    localStorage.setItem('todo', JSON.stringify(this.request.todoLists.serialize()))
    types.handling.handled()


module.exports = {
  TodoList, TodoLists,
  TodoListFetchRequest, TodoListFetchStore,
  TodoListSaveRequest, TodoListSaveStore,
  registerWith: (library) ->
    library.register(TodoListFetchRequest, TodoListFetchStore)
    library.register(TodoListSaveRequest, TodoListSaveStore)
}

