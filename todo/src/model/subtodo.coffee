{ Model, attribute, List } = require('janus')

Subtodo = Model.build(
  attribute('name', attribute.Text)
  attribute('done', attribute.Boolean)
)
Subtodos = List.of(Subtodo)

module.exports = { Subtodo, Subtodos }

