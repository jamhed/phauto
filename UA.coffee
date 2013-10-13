module.exports = 
class UA
  
   page:    null
   steps:   null
   step:    null

   verbose: false

   retryTimeout: 100
   waitTimeout: 5000

   constructor: ->
      @steps = []
      @page = require("webpage").create()

      @page.onResourceRequested = (r) => @debug "request() #{r.url}" if @verbose
      @page.onLoadFinished = (r) => @nextStep "onLoadFinished"
      @page.onConsoleMessage = (msg) => @debug "CONSOLE: #{msg}" if @verbose
      @page.onError = (msg) => @debug "CLIENT ERROR: #{msg}"

      @page.viewportSize = { width: 1024, height: 768 }

   debug: (args...) -> console.log args.join(" ")

   ok: (text, condition) -> if condition then @debug "OK:", text else @debug "FAIL:", text; @exit()
 
   nextStep: (args...) ->
      @step = @steps.shift()
      if @step
         @debug "DO:", @step.desc
         @step.fn.call(@, args)
      else
         @onStepComplete()

   then: (desc, fn) -> @steps.push fn: fn, desc: desc

   cleanup: ->
      fs = require "fs"
      fs.removeTree @page.offlineStoragePath
   
   exit: ->
      @cleanup()
      phantom.exit()

   onError: (msg) ->
      @debug "ERROR: #{msg}"
      @exit()

   onTimeout: ->
      @debug "TIMEOUT:", @step.desc if @step
      @exit()

   onStepComplete: -> @exit()