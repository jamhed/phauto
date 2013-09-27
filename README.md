# PhantomJS scripts.

[PhantomJS](http://phantomjs.org) is a headless WebKit scriptable with a JavaScript API.
This project is inspired by CasperJS, but much, much smaller, although provides all
necessary methods to automate complex web pages tests.

Usage scenario is sequence of steps, defined by then() method. Each successful page load
and wait events advance current step forward while wait timeout and page errors stops execution.

This library depends on jQuery for working with page scope, and injects jQuery to target pages
after first page load.

Methods click() and text() are for clicking on jQuery-selected element and for entering text. Text is entered by
calling PhantomJS sendEvent method with "keypress" event, after clicking in the "middle" of an element.

Method wait() waits for condition (defaults to check html element existance). Please note when page loads
(reloads) all timers like setInterval or setTimeout are cleared, and thus should be re-established.

PhantomJS uses CommonJS module format and looks up for required modules in node_modules directories,
starting from script directory and up four levels. To trick it create symlink to script directory: ln -s ./ node_modules.

# Usage

$ phantomjs test.coffee

# Scopes

There are two independent "scopes": one is phantomjs itself, and other is a target page. Communication between
scopes is done via event handlers and quite limited function "evaluate". It cannot pass back to phantom scope
complex structures like HTMLEntity and JQuery objects, and that's why I've implemented jQuery method: it runs
passed code with selected jquery element in scope of target page.
