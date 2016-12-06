{ DomView, template, find, from } = require('janus')
$ = require('jquery')

{ Subtodo } = require('../model/subtodo')

class SubtodoView extends DomView
  @_dom: -> $('
    <div class="subtodo">
      <div class="subtodoCheck"></div>
      <div class="subtodoName"></div>
    </div>
  ')

  @_template: template(
    find('.subtodo').classed('done', from('done'))
    find('.subtodoCheck').render(from.attribute('done')).context('edit')
    find('.subtodoName').render(from.attribute('name')).context('edit')
  )

module.exports = { SubtodoView, registerWith: (library) -> library.register(Subtodo, SubtodoView) }

