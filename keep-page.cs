root = exports ? this
root.fn = (ua) ->

   ua.tr "logged", "ajax/finish", "logged", () ->
      fs = require "fs"
      fs.removeTree phantom.page.offlineStoragePath
      
      @click "[href='#show']"
      @wait "li[name='page']", "show/ready", (selector) => @innerText(selector) == "1 / 2"

   ua.tr "logged", "show/ready", "show", () ->
      @click_jq "li[name='forward']"
      @wait "li[name='page']", "show/forward", (selector) => @innerText(selector) == "2 / 2"   

   ua.tr "show", "show/forward", "show", ->
      @click "[href='#event']"
      @wait "li[name='page']", "ready", (selector) => @innerText(selector) == "1 / 1"

   ua.tr "show", "ready", "event", ->
      @click "[href='#show']"
      @wait "li[name='page']", "show/click", (selector) => @innerText(selector) == "2 / 2"

   ua.tr "event", "show/click", "show/edit", ->
      @click "[pi='Create']"
      @wait "[pi='a/Form'][processed=1]", "ready"

   ua.tr "show/edit", "ready", "show", ->
      @page.goBack()
      @wait "li[name='page']", "back", (selector) => @innerText(selector) == "2 / 2"

   ua.tr "show", "back", "show", ->
      console.log "OK: сохранение выбранной страницы при переходах"
      fs = require "fs"
      fs.removeTree phantom.page.offlineStoragePath
      phantom.exit()
   
   return ua