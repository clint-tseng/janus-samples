{ Model, attribute, List, types } = require('janus')
{ Store, request } = require('janus').store
{ Todos } = require('./todo')


class TodoList extends Model
  @attribute('name', attribute.TextAttribute)

  @attribute 'todos', class extends attribute.CollectionAttribute
    @collectionClass: Todos
    default: -> new Todos()
    writeDefault: true

class TodoLists extends List
  @modelClass: TodoList


# normally, there'd be more to this class. parameters for which ID to fetch, or
# cache-key computation, or any number of other things relevant to the context
# of a request. but because we literally just have one piece of data that's
# nearly infinitely cheap to fetch, all this class really does is serve as a
# token to be instantiated and passed around.
class TodoListFetchRequest extends request.FetchRequest

class TodoListFetchStore extends Store
  _handle: ->
    stored = localStorage.getItem('todo')
    this.request.set(types.result.success(if stored? then JSON.parse(stored) else []))
    Store.Handled


# similarly, here is a request to save. it's not atypical to simply let the
# Request superclass's general @options intake handle all the parameters we
# might need, but here we make it explicit just to show how you can.
class TodoListSaveRequest extends request.UpdateRequest
  constructor: (@todoLists, @options = {}) ->
    super(@options)

class TodoListSaveStore extends Store
  _handle: ->
    localStorage.setItem('todo', JSON.stringify(this.request.todoLists.serialize()))
    Store.Handled


module.exports = {
  TodoList, TodoLists,
  TodoListFetchRequest, TodoListFetchStore,
  TodoListSaveRequest, TodoListSaveStore,
  registerWith: (library) ->
    library.register(TodoListFetchRequest, TodoListFetchStore)
    library.register(TodoListSaveRequest, TodoListSaveStore)
}

