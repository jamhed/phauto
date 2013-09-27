module.exports = (ua) ->

   ua.then "открываем страницу", (uri) -> @page.open uri
   ua.then "подключаем к странице jquery", -> @page.includeJs "/js/lib/jquery.js", => @nextStep()
   ua.then "заполняем форму логина", ->
      @text "input[name='name']", "admin"
      @text "input[name='password']", "admin"
      @click "input[type='submit']"
   ua.then "ждем загрузки всех скриптов", ->
      @wait "script[src^='/js/a/Source.js']"
      
   return ua
