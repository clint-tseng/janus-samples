{ DomView, template, find, from } = require('janus')
$ = require('jquery')

{ Subtodo } = require('../model/subtodo')

SubtodoView = DomView.build($('
  <div class="subtodo">
    <div class="subtodoCheck"></div>
    <div class="subtodoName"></div>
  </div>
'), template(
  find('.subtodo').classed('done', from('done'))
  find('.subtodoCheck').render(from.attribute('done')).context('edit')
  find('.subtodoName').render(from.attribute('name'))
    .context('edit')
    .options({ placeholder: '(new subitem)' })
))

module.exports = { SubtodoView, registerWith: (library) -> library.register(Subtodo, SubtodoView) }

