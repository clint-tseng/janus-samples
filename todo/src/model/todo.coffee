{ Model, attribute, List } = require('janus')
{ Subtodos } = require('./subtodo')

class Todo extends Model
  @attribute('name', attribute.TextAttribute)
  @attribute('description', attribute.TextAttribute)

  @attribute 'subitems', class extends attribute.CollectionAttribute
    @collectionClass: Subtodos
    default: -> new Subtodos()
    writeDefault: true

  @attribute('done', attribute.BooleanAttribute)

class Todos extends List
  @modelClass: Todo

module.exports = { Todo, Todos }

