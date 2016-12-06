{ Model, attribute, List } = require('janus')
{ TodoLists } = require('../model/todo-list')

class Main extends Model
  @attribute 'todoLists', class extends attribute.CollectionAttribute
    @collectionClass: TodoLists
    default: -> new TodoLists()
    writeDefault: true

  @attribute 'current', class extends attribute.EnumAttribute
    values: -> this.model.watch('todoLists')
    transient: true

module.exports = { Main }

