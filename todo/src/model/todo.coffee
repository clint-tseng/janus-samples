{ Model, attribute, List } = require('janus')
{ Subtodos } = require('./subtodo')

Todo = Model.build(
  attribute('name', attribute.Text)
  attribute('description', attribute.Text)

  attribute 'subitems', class extends attribute.Collection
    @collectionClass: Subtodos
    default: -> new Subtodos()
    writeDefault: true

  attribute('done', attribute.Boolean)
)
Todos = List.of(Todo)

module.exports = { Todo, Todos }

