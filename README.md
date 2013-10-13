# PhantomJS automation.

[PhantomJS](http://phantomjs.org) is a headless WebKit scriptable with a JavaScript API.
This project is inspired by CasperJS, but much, much smaller, although provides all
necessary methods to automate complex web pages tests.

Key ideas:

1. Rely on jQuery with html-element selecting
2. Steps and wait() function

# Usage

$ phantomjs test.coffee

# Steps

Script consists of a number of steps executed in sequential order. Each step consists of two (three) parts:

1. Current state processing, like checks for element, parsing content, etc
2. Action (page load, click)
3. Wait condition

Thus click() method combines selector to click, selector to wait and optional check-function (default is to check
for existance).

# Clicking and entering text

Methods click() and text() are for clicking on jQuery-selected element and for entering text. Text is entered by
calling PhantomJS sendEvent method with "keypress" event, after clicking in the "middle" of an element.

# Waiting

Method wait() waits for condition (defaults to check html element existance). Please note when page loads
(reloads) all timers like setInterval or setTimeout are cleared, and thus should be re-established.

# Modules

PhantomJS uses CommonJS module format and looks up for required modules in node_modules directories,
starting from script directory and up four levels. To trick it create symlink to script directory: ln -s ./ node_modules.

# Execution scopes

There are two independent "scopes": one is phantomjs itself, and other is a target page. Communication between
scopes is done via event handlers and quite limited function "evaluate". It cannot pass back to phantom scope
complex structures like HTMLEntity and JQuery objects, and that's why I've implemented jQuery method: it runs
passed code with selected jquery element in scope of target page.
