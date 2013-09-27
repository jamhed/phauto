# PhantomJS scripts.

[PhantomJS](http://phantomjs.org) is a headless WebKit scriptable with a JavaScript API. This project inspired by CasperJS, but much smaller.


There are two independent "scopes": one is phantomjs itself, and other is a target page. Communication between
scopes is done via event handlers and quite limited function "evaluate". It cannot pass back to phantom scope
complex structures like HTMLEntity and JQuery objects, and that's why I've implemented jQuery method: it runs
passed code with selected jquery element in scope of target page.

Methods click and text are for clicking on jQuery-selected element and for entering text. Text is entered by
calling phantomjs sendEvent method, with "keypress" event, after clicking in the "middle" of an element.

Method wait waits for specified element to arrive on page (in case of ajax loading page parts, require.js scripts,
et cetera). Please note when page loads (reloads) all timers like setInterval or setTimeout are cleared,
and thus should be re-established.

PhantomJS uses CommonJS module format and looks up for required modules in node_modules directories,
starting from script directory and up four levels. To trick it create symlink to script directory: ln -s ./ node_modules.

# Usage

$ phantomjs test.coffee
