{ Model, attribute, DomView, template, find, from } = require('janus')
$ = require('jquery')

{ Todo } = require('../model/todo')
{ Subtodo } = require('../model/subtodo')

# if this were more substantial it would probably deserve its own view in
# src/viewmodel/, but as-is it can just live here.
class TodoVM extends Model
  # you may ask: why use a boolean attribute for expanding/collapsing a block
  # when it's a couple trivial lines to do so directly in jQuery? one reason is
  # merely pedagogical: this is an opportunity to show the use of ViewModels.
  # there's nothing wrong with patching simple behaviour in with jQuery directly;
  # it's really a matter of taste. i prefer doing things this way because
  # otherwise you have to be able to draw a philosophical line on what's okay
  # and what's complex enough to merit piping the logic through a ViewModel.
  @attribute 'expanded', class extends attribute.BooleanAttribute
    default: -> false

  # we create a subtodo we don't really care about just to easily drop it on the
  # page as a ghost the user can click on to create a new item.
  @bind('dummySubitem', from(-> new Subtodo()))

class TodoView extends DomView
  @viewModelClass: TodoVM
  @_dom: -> $('
    <div class="todo">
      <div class="summaryLine">
        <div class="todoCheck"></div>
        <div class="todoTitle"></div>
        <div class="todoExpand"></div>
      </div>
      <div class="detailLine">
        <div class="todoDescription"></div>
        <div class="todoSubitems"></div>
        <div class="todoDummySubitem"></div>
      </div>
    </div>
  ')

  @_template: template(
    find('.todo').classed('done', from('subject').watch('done'))

    find('.todoCheck').render(from('subject').attribute('done')).context('edit')
    find('.todoTitle').render(from('subject').attribute('name')).context('edit')
    find('.todoExpand').render(from.attribute('expanded')).context('edit').find( attributes: { style: 'button' } )
    find('.detailLine').classed('expanded', from('expanded'))

    find('.todoDescription').render(from('subject').attribute('description')).context('edit').find( attributes: { style: 'multiline' })
    find('.todoSubitems').render(from('subject').watch('subitems')).context('edit')
    find('.todoDummySubitem').render(from('dummySubitem'))
  )

  _wireEvents: ->
    dom = this.artifact()

    # our "subject" is the viewmodel; the actual Todo is saved onto that ViewModel
    # under the attribute 'subject'.
    todo = this.subject.get('subject') 

    # if the user clicks on the dummy/ghost entry, create a new subitem and
    # focus on the appropriate part of that instead.
    dom.on('click', '.todoDummySubitem', (event) ->
      event.preventDefault()
      newSubtodo = new Subtodo()
      todo.get('subitems').add(newSubtodo)

      # find that new subtodo we just added and focus on the appropriate part.
      newSubtodoDom = dom.find('.todoSubitems li:last .subtodo')
      if $(event.target).is('input[type=checkbox]')
        newSubtodo.set('done', true)
        newSubtodoDom.find('input[type=checkbox]').focus()
      else
        newSubtodoDom.find('input[type=text]').focus()
    )

module.exports = { TodoVM, TodoView, registerWith: (library) -> library.register(Todo, TodoView) }

