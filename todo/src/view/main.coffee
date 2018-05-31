$ = require('jquery')
{ DomView, template, find, from } = require('janus')
{ TodoList } = require('../model/todo-list')
{ Main } = require('../viewmodel/main')

MainView = DomView.build($('
  <div class="main">
    <div class="left">
      <div class="todoList"></div>
      <div class="toolbar">
        <button class="addTodoList">New</button>
      </div>
    </div>
    <div class="right contents"></div>
  </div>
'), template(
  find('.left .todoList').render(from.attribute('current')).context('edit').criteria( attributes: { style: 'list' } )
  find('.right').render(from('current'))

  find('button').on('click', (_, subject) ->
    newTodoList = new TodoList() # make a new todo list.
    subject.get('todoLists').add(newTodoList) # drop it onto the main list.
    subject.set('current', newTodoList) # switch to the new list.
  )
))

module.exports = { MainView, registerWith: (library) -> library.register(Main, MainView) }

