root = exports ? this
root.fn = (ua) ->

   ua.tr "page/requested", "page/open", "open", ->
      @page.includeJs "/js/lib/jquery.js", => @run "page/jquery"

   ua.tr "open", "page/jquery", "ready", ->
      @text "input[name='name']", "admin"
      @text "input[name='password']", "admin"
      @click "input[type='submit']"

   ua.tr "ready", "page/finish", "logged", ->
      @wait "script[src^='/js/a/Source.js']", "ajax/finish"

   return ua