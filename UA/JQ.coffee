module.exports = 
class UAJQ extends require("UA.coffee")
   
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
