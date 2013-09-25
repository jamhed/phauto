phantom.injectJs("./UA.js")

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
