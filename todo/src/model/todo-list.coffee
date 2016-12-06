{ Model, attribute, List } = require('janus')
{ Todos } = require('./todo')

class TodoList extends Model
  @attribute('name', attribute.TextAttribute)

  @attribute 'todos', class extends attribute.CollectionAttribute
    @collectionClass: Todos
    default: -> new Todos()
    writeDefault: true

class TodoLists extends List
  @modelClass: TodoList

module.exports = { TodoList, TodoLists }

