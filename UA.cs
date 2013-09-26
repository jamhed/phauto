root = exports ? this
root.class = class UA
   
   page: null
   rules: null
   state: "init"

   debug: false

   retryTimeout: 100
   waitTimeout: 5000

   constructor: ->
      @rules = {}
      @page = require("webpage").create()

      @page.onResourceRequested = (r) => console.log "request() #{r.url}" if @debug

      @page.onLoadFinished = (r) => @run "page/finish"

      @tr "init", "page/open", "page/requested", (uri) ->
         @page.open uri, (status) => @run "page/open", status

      @page.onConsoleMessage = (msg) => console.log "CONSOLE: #{msg}" if @debug
      @page.onError = (msg) -> console.log "ERROR: #{msg}"

      @page.viewportSize = { width: 1024, height: 768 }
   
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

   click_jq: (selector) -> @jQuery selector, () -> @.click()

   text: (selector, text) ->
      @click selector
      @page.sendEvent "keypress", text

   exists: (selector) -> @jQuery selector, -> return (this.length > 0)

   innerText: (selector) -> @jQuery selector, -> return this.text()

   wait: (selector, ev, check = (selector) => @exists(selector)) ->
      start = new Date().getTime()
      handler = setInterval (() => 
         status = check(selector)
         if status
            clearInterval handler
            @run ev
         if (new Date().getTime() - start > @waitTimeout)
            clearInterval handler
            @run "timeout #{ev}"
      ), @retryTimeout
