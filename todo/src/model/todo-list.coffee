{ Varying, Model, attribute, Request, List, types } = require('janus')
{ Todos } = require('./todo')


TodoList = Model.build(
  attribute('name', attribute.Text)

  attribute 'todos', class extends attribute.List.of(Todos)
    default: -> new Todos()
)
TodoLists = List.of(TodoList)


# normally, there'd be more to this class. parameters for which ID to fetch, or
# cache-key computation, or any number of other things relevant to the context
# of a request. but because we literally just have one piece of data that's
# nearly infinitely cheap to fetch, all this class really does is serve as a
# token to be instantiated and passed around.
class TodoListFetchRequest extends Request

fetchLocalData = (request) ->
  stored = localStorage.getItem('todo')
  result =
    if stored?
      TodoLists.deserialize(JSON.parse(stored))
    else
      new TodoLists()
  new Varying(types.result.success(result))


# similarly, here is a request to save. it's not atypical to simply let the
# Request superclass's general @options intake handle all the parameters we
# might need, but here we make it explicit just to show how you can.
class TodoListSaveRequest extends Request
  constructor: (@todoLists) -> super()
  type: types.operation.update()

saveLocalData = (request) ->
  localStorage.setItem('todo', JSON.stringify(request.todoLists.serialize()))
  new Varying(types.result.success())


module.exports = {
  TodoList, TodoLists,
  TodoListFetchRequest, fetchLocalData,
  TodoListSaveRequest, saveLocalData,
  registerWith: (library) ->
    library.register(TodoListFetchRequest, fetchLocalData)
    library.register(TodoListSaveRequest, saveLocalData)
}

