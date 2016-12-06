{ Model, attribute, List } = require('janus')

class Subtodo extends Model
  @attribute('name', attribute.TextAttribute)
  @attribute('done', attribute.BooleanAttribute)

class Subtodos extends List
  @modelClass: Subtodo

module.exports = { Subtodo, Subtodos }

