Todo Janus Sample App
=====================

This is a sample app demonstrating the basic capabilities of [Janus](http://janusjs.org) ([GitHub](https://github.com/clint-tseng/janus)). It also uses the [Janus Standard Library](https://github.com/clint-tseng/janus-stdlib).

It seems like Todo apps are all the rage for demonstrating new frameworks, so here is our attempt. For fun, it's written as an Electron app, though if you package up the JS (eg via Browserify) and load the HTML file in a browser it ought to work perfectly fine.

The following aspects are shown in this sample:

* Models and attribute definition.
* Collections and collection manipulation methods.
* Views and templates; how to bind data to the DOM.
* Philosophy and techniques around functionality like masked inputs and expanding sections.
* Basic remote resource fetch and push.

Being introductory, the sample is lacking in some ways:

* Complex techniques.
* Localization.
* Server-based application rendering/handling. And in general, the `application` sub-bundle in Janus.
* Page navigation handling techniques.
* Operational aspects like client JS bundling.

Building
--------

Pretty simple; if you have `npm` installed then `make` should build everything. And if you have `electron` already, all it takes is `electron .` following in order to run the application.

Walkthrough
-----------

Screencast video and written documentation is coming.

Challenge problems
------------------

Try adding some of the following functionality as a sort of challenge; they're roughly in increasing order of difficulty:

* Allow a top-level TodoList to be removed after it's created.
* Allow a color or emoji to be assigned to each Todo. Especially for color, the `classGroup` mutation should prove to be useful.
* Show the total number of sub-Todos that exist and are completed in addition to the top-level. `List#map()` will be your friend.
* Instead of clicking New to add a Todo, make it behave like the sub-Todos do.
* Allow each todo to be able to point at one or more prerequisite todos from the same list. Go to and highlight that todo when clicked.
* Suggest others via pull request!

License
-------

All of the Janus sample apps are licensed under the [WTFPL](http://www.wtfpl.net/about/).

