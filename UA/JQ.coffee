module.exports = 
class UAJQ extends require("UA.coffee")
   
   jQuery: (selector, fn) ->
      @page.evaluate ((selector, fn) -> return fn.call $(selector)), selector, fn

   box: (selector) ->
      @jQuery selector, -> x: @.offset().left, y: @.offset().top, w: @.width(), h: @.height() if @[0]

   click: (selector, wait, check) ->
      box = @box selector
      if box
         @page.sendEvent "click", box.x + box.w/2, box.y + box.h/2
         @wait wait, check
      else
         @debug "FAIL click on: #{selector}"
         @exit()
   
   text: (selector, text) ->
      @click selector
      @page.sendEvent "keypress", text

   exists: (selector) -> @jQuery selector, -> (this.length > 0)

   numberOf: (selector) -> @jQuery selector, -> this.length

   innerText: (selector) -> @jQuery selector, -> this.text()

   val: (selector) -> @jQuery selector, -> this.val()

   wait: (selector, check = (selector) => @exists(selector)) ->
      start = new Date().getTime()
      handler = setInterval (() => 
         status = check(selector)
         if status
            clearInterval handler
            @nextStep()
         if (new Date().getTime() - start > @waitTimeout)
            clearInterval handler
            @onTimeout()
      ), @retryTimeout