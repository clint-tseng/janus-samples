$ = require('jquery')
{ DomView, template, find, from } = require('janus')
{ TodoList } = require('../model/todo-list')
{ Main } = require('../viewmodel/main')

class MainView extends DomView
  @_dom: -> $('
    <div class="main">
      <div class="left">
        <div class="todoList"></div>
        <div class="toolbar">
          <button class="addTodoList">New</button>
        </div>
      </div>
      <div class="right contents"></div>
    </div>
  ')

  @_template: template(
    find('.left .todoList').render(from.attribute('current')).context('edit').find( attributes: { style: 'list' } )
    find('.right').render(from('current'))
  )

  _wireEvents: ->
    dom = this.artifact() # get our fragment.

    dom.find('button.addTodoList').on('click', =>
      newTodoList = new TodoList() # make a new todo lists.
      this.subject.get('todoLists').add(newTodoList) # drop it into the main list.
      this.subject.set('current', newTodoList) # switch to the new list.
    )

module.exports = { MainView, registerWith: (library) -> library.register(Main, MainView) }

