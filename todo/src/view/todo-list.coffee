$ = require('jquery')
{ DomView, template, find, from } = require('janus')
{ TodoList } = require('../model/todo-list')
{ Todo } = require('../model/todo')

# util.
blank = (x) -> !x? or x is ''
textOrElse = (fallback) -> (x) -> if blank(x) then fallback else x

TodoListSummaryView = DomView.build($('
  <div class="todoListSummary">
    <div class="name"></div>
    <div class="completion">
      <span class="completed"></span>/<span class="total"></span> completed
    </div>
  </div>
'), template(
  find('.name').text(from('name').map(textOrElse('(untitled list)')))

  # we filter all our todos by their done state, then watch the length to get a count.
  find('.completion .completed').text(
    from('todos').flatMap((list) ->
      list.filter((todo) -> todo.watch('done')).watchLength()
  ))

  # here, we just watch the length. note how we flatMap in both cases, since
  # .watchLength() returns a Varying.
  find('.completion .total').text(from('todos').flatMap((list) -> list.watchLength()))
))

TodoListView = DomView.build($('
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
'), template(
  # here we ask for a context of 'edit', so the library knows what to return.
  find('.todoList-titleField').render(from.attribute('name')).context('edit')

  # the ghost field positions the pencil icon:
  find('.todoList-titleGhost').text(from('name').map(textOrElse('(untitled list)')))
  find('.todoList-titleWrapper').classed('hasText', from('name').map((x) -> !blank(x)))

  # to render the todos list, we just ask for it. all changes to the list are
  # handled automatically by the framework.
  find('.todos').render(from('todos'))

  # n.b. here we have to flatMap rather than map! this is because watchLength
  # itself returns a Varying, so if we just mapped we be trying to assess
  # whether to apply the element class based on a Varying rather than a Boolean.
  find('.empty').classed('hide', from('todos').flatMap((list) -> list.watchLength().map((x) -> x > 0)))

  # finally, when the New button is clicked, add a new Todo to the list.
  find('button').on('click', (_, subject) -> subject.get('todos').add(new Todo()))
))

module.exports = {
  TodoListSummaryView,
  registerWith: (library) ->
    library.register(TodoList, TodoListSummaryView, context: 'summary')
    library.register(TodoList, TodoListView)
}

