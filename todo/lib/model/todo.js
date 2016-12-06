// Generated by CoffeeScript 1.11.1
(function() {
  var List, Model, Subtodos, Todo, Todos, attribute, ref,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ref = require('janus'), Model = ref.Model, attribute = ref.attribute, List = ref.List;

  Subtodos = require('./subtodo').Subtodos;

  Todo = (function(superClass) {
    extend(Todo, superClass);

    function Todo() {
      return Todo.__super__.constructor.apply(this, arguments);
    }

    Todo.attribute('name', attribute.TextAttribute);

    Todo.attribute('description', attribute.TextAttribute);

    Todo.attribute('subitems', (function(superClass1) {
      extend(_Class, superClass1);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.collectionClass = Subtodos;

      _Class.prototype["default"] = function() {
        return new Subtodos();
      };

      _Class.prototype.writeDefault = true;

      return _Class;

    })(attribute.CollectionAttribute));

    Todo.attribute('done', attribute.BooleanAttribute);

    return Todo;

  })(Model);

  Todos = (function(superClass) {
    extend(Todos, superClass);

    function Todos() {
      return Todos.__super__.constructor.apply(this, arguments);
    }

    Todos.modelClass = Todo;

    return Todos;

  })(List);

  module.exports = {
    Todo: Todo,
    Todos: Todos
  };

}).call(this);