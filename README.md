# Phantom.js finite-state automation


[PhantomJS](http://phantomjs.org) is a headless WebKit scriptable with a JavaScript API. Phantom-FSM is a finite
state automata designed to express user behaviour.

There are two independent "scopes": one is phantomjs itself, and other is a target page. Communication between
scopes is done via event handlers and quite limited function "evaluate". It cannot pass back to phantom scope
complex structures like HTMLEntity and JQuery objects, and that's why I've implemented jQuery method: it runs
passed code with selected jquery element in scope of target page.

UA class is a finite state machine. It has state and rules. Rules are described with tr(-ansition) method,
as initial state, event, next state and callback that is executed on transition. This allows to express
web-page interaction in terms of states and transitions, like sequence of action, awaited response, action, response,
et cetera, without passing explicit callbacks.

Methods click and text are for clicking on jQuery-selected element and for entering text. Text is entered by
calling phantomjs sendEvent method, with "keypress" event, after clicking in the "middle" of an element.

Method wait waits for specified element to arrive on page (in case of ajax loading page parts, require.js scripts,
et cetera). Please note when page loads (reloads) all timers like setInterval or setTimeout are cleared,
and thus should be re-established.

PhantomJS has a weird method of module includes, injectJs?

# Usage

Just define desired fsm behaviour and then execute phantomjs fsm.coffee to see results.
