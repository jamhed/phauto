class UA
   
   page: null
   state: "init"
   rules: null

   retryTimeout: 100
   waitTimeout: 5000

   constructor: ->
      @rules = {}
      @page = require("webpage").create()

      @page.onResourceRequested = (r) -> console.log "request() #{r.url}"

      @page.onLoadFinished = (r) => @run "page/finish"

      @tr "init", "page/open", "page/requested", (uri) ->
         @page.open uri, (status) => @run "page/open", status

      @page.onConsoleMessage = (msg) -> console.log "CONSOLE: #{msg}"
      @page.onError = (msg) -> console.log "ERROR: #{msg}"

   tr: (state, ev, newstate, fn) ->
      @rules[state] = {} if ! @rules[state]
      @rules[state][ev] = fn: fn, newstate: newstate

   run: (ev, args...) ->
      console.log "run() #{@state} -> #{ev}"
      if ! @rules[@state]
         return console.log "No rules for state #{@state}"
      if ! @rules[@state][ev]
         return console.log "No event #{ev} on state #{@state}"

      tr = @rules[@state][ev]
      return unless tr
      @state = tr.newstate
      tr.fn.call(@, args) if tr.fn

   jQuery: (selector, fn) ->
      @page.evaluate ((selector, fn) -> return fn.call $(selector)), selector, fn

   box: (selector) ->
      @jQuery selector, -> x: @.offset().left, y: @.offset().top, w: @.width(), h: @.height()

   click: (selector) ->
      box = @box selector
      @page.sendEvent "click", box.x + box.w/2, box.y + box.h/2

   text: (selector, text) ->
      @click selector
      @page.sendEvent "keypress", text

   wait: (selector, ev) ->
      start = new Date().getTime()
      handler = setInterval (() => 
         status = @jQuery selector, -> return (this.length > 0)
         if status
            clearInterval handler
            @run ev
         if (new Date().getTime() - start > @waitTimeout)
            clearInterval handler
            @run "timeout"
      ), @retryTimeout

ua = new UA 

ua.tr "page/requested", "page/open", "open", ->
   @page.includeJs "/js/lib/jquery.js", => @run "page/jquery"

ua.tr "open", "page/jquery", "ready", ->
   @text "input[name='name']", "admin"
   @text "input[name='password']", "admin"
   @click "input[type='submit']"

ua.tr "ready", "page/finish", "logged", ->
   @wait "script[src^='/js/a/Source.js']", "ajax/finish"

ua.tr "logged", "ajax/finish", "logged", () ->
   console.log "logged on"

ua.tr "logged", "timeout", "logged", () ->
   console.log "timeout"

ua.run "page/open", "http://localhost:3000/login"