$ = require('jquery')
{ DomView, template, find, from } = require('janus')
{ TodoList } = require('../model/todo-list')
{ Todo } = require('../model/todo')

# util.
blank = (x) -> !x? or x is ''
textOrElse = (fallback) -> (x) -> if blank(x) then fallback else x

class TodoListSummaryView extends DomView
  @_dom: -> $('
    <div class="todoListSummary">
      <div class="name"></div>
      <div class="completion">
        <span class="completed"></span>/<span class="total"></span> completed
      </div>
    </div>
  ')

  @_template: template(
    find('.name').text(from('name').map(textOrElse('(untitled list)')))

    find('.completion .completed').text(
      from('todos').map((list) ->
        list.filter((todo) -> todo.watch('done')).watchLength()
    ))

    find('.completion .total').text(from('todos').map((list) -> list.watchLength()))
  )

class TodoListView extends DomView
  @_dom: -> $('
    <div class="todoList">
      <div class="todoList-titleWrapper">
        <span class="todoList-titleField"></span>
        <span class="todoList-titleGhost"></span>
      </div>
      <div class="todos"></div>
      <div class="empty">No items yet.</div>
      <div class="toolbar">
        <button class="addTodo">New</button>
      </div>
    </div>
  ')

  @_template: template(
    find('.todoList-titleField').render(from.attribute('name')).context('edit')

    # the ghost field positions the pencil icon:
    find('.todoList-titleGhost').text(from('name').map(textOrElse('(untitled list)')))
    find('.todoList-titleWrapper').classed('hasText', from('name').map((x) -> !blank(x)))

    find('.todos').render(from('todos'))

    # n.b. here we have to flatMap rather than map! this is because watchLength
    # itself returns a Varying, so if we just mapped we be trying to assess
    # whether to apply the element class based on a Varying rather than a Boolean.
    find('.empty').classed('hide', from('todos').flatMap((list) -> list.watchLength().map((x) -> x > 0)))
  )

  _wireEvents: ->
    dom = this.artifact() # get our fragment.

    # on click, get our todos list and add a new one.
    dom.find('button.addTodo').on('click', => this.subject.get('todos').add(new Todo()))

module.exports = {
  TodoListSummaryView,
  registerWith: (library) ->
    library.register(TodoList, TodoListSummaryView, context: 'summary')
    library.register(TodoList, TodoListView)
}

