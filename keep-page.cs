root = exports ? this
root.fn = (ua) ->

   ua.then "переход на страницу программ", ->
      @cleanup()
      @click "[href='#show']"
      @wait "li[name='page']", (selector) => @innerText(selector) == "1 / 2"

   ua.then "проматываем на одну страницу вперед", ->
      @click_jq "li[name='forward']"
      @wait "li[name='page']", (selector) => @innerText(selector) == "2 / 2"   

   ua.then "переход на страницу событий", ->
      @click "[href='#event']"
      @state = "event page"
      @wait "li[name='page']", (selector) => @innerText(selector) == "1 / 1"

   ua.then "переход на страницу программ со страницы событий", ->
      @click "[href='#show']"
      @state = "show page"
      @wait "li[name='page']", (selector) => @innerText(selector) == "2 / 2"

   ua.then "клик по кнопке добавить", ->
      @click "[pi='Create']"
      @wait ".cke_wysiwyg_frame"

   ua.then "возврат со страницы добавления программы", ->
      @page.goBack()
      @wait "li[name='page']", (selector) => @innerText(selector) == "2 / 2"

   ua.then "конец теста", -> @exit()
   
   return ua