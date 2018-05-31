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

TodoView = DomView.build($('
  <div class="todo">
    <div class="summaryLine">
      <div class="todoCheck"></div>
      <div class="todoExpand"></div>
      <div class="todoTitle"></div>
    </div>
    <div class="detailLine">
      <div class="todoDescription"></div>
      <div class="todoSubitems"></div>
      <div class="todoDummySubitem"></div>
    </div>
  </div>
'), template(

  find('.todo').classed('done', from('subject').watch('done'))

  find('.todoCheck').render(from('subject').attribute('done')).context('edit')
  find('.todoTitle').render(from('subject').attribute('name'))
    .context('edit')
    .options( placeholder: '(new todo)' )

  find('.todoExpand').render(from.attribute('expanded'))
    .context('edit')
    .criteria( attributes: { style: 'button' } )
    .options( stringify: (x) -> if x is true then '\u25bc' else '\u25c0' )
  find('.detailLine').classed('expanded', from('expanded'))

  find('.todoDescription').render(from('subject').attribute('description'))
    .context('edit')
    .criteria( attributes: { style: 'multiline' })
    .options( placeholder: '(details)' )
  find('.todoSubitems').render(from('subject').watch('subitems')).context('edit')
  find('.todoDummySubitem').render(from('dummySubitem'))

  # if the user clicks on the dummy/ghost entry, create a new subitem and
  # focus on the appropriate part of that instead.
  find('.todo').on('click', '.todoDummySubitem', (event, subject, _, dom) ->
    event.preventDefault()
    newSubtodo = new Subtodo()

    # add the new subtodo. because we are using a ViewModel, our "true" Todo
    # subject needs to be first fetched; it is stored on the ViewModel as "subject".
    subject.get('subject').get('subitems').add(newSubtodo)

    # find that new subtodo we just added and focus on the appropriate part.
    newSubtodoDom = dom.find('.todoSubitems li:last .subtodo')
    if $(event.target).is('input[type=checkbox]')
      newSubtodo.set('done', true)
      newSubtodoDom.find('input[type=checkbox]').focus()
    else
      newSubtodoDom.find('input[type=text]').focus()
  )

), { viewModelClass: TodoVM })

module.exports = { TodoVM, TodoView, registerWith: (library) -> library.register(Todo, TodoView) }

