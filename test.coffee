UAJQ = require("UA/JQ.coffee")

ua = new UAJQ

test_create_update_delete = (ua, name) ->
   ua.then "click new",      ->
      @click "#0", ".ui-dialog-title"

   ua.then "create #{name}", ->
      @text "input[name=name]", "test"
      @click "button:contains(Сохранить)", "td:contains(test)"
   
   ua.then "edit created #{name}", ->
      @click "tr:contains(test) a", ".ui-dialog-title"

   ua.then "update created #{name}", ->
      @text "input[name=name]", " test"
      @click "button:contains(Сохранить)", "td:contains(test test)"

   ua.then "edit updated #{name}", ->
      @click "tr:contains(test test) a:contains(Править)", ".ui-dialog-title"

   ua.then "delete created #{name}", ->
      @click "button:contains(Удалить)", "td:contains(text test)", (s) => ! @exists(s)

ua.then "main page", (uri)  -> @page.open uri

ua.then "wait for scripts", -> @wait "script[src^='/js/lib/markdown/lib/markdown.js']"
ua.then "click on roles",   -> @click "[href='#!role']", "td:contains(master)"
ua.then "edit master",      -> @click "#3", ".ui-dialog-title"
ua.then "check form",       ->
   @ok "admin name", "admin" == @val "input[name=name]"
   @ok "admin prefix", "admin" == @val "input[name=prefix]"
   @click "button:contains(Сохранить)", ".ui-dialog-title", (s) => ! @exists(s)

ua.then "admin rules",      -> @click "a[href='#rbac/rule?role_id=3']", "tbody[uri='/rbac/rule/table'][processed]"

ua.then "check rules",      ->
   @ok "number of rows", 2 == @numberOf "tr"
   @click "#0", ".ui-dialog-title"

ua.then "new rule for admin", ->
   @text "input[name=name]", "test rule"
   @text "input[name=match]", "test match"
   @click "button:contains(Сохранить)", "td:contains(test rule)"

ua.then "edit created rule", ->
   @click "td:contains(test rule) + td + td a", ".ui-dialog-title"

ua.then "update created rule", ->
   @text "input[name=name]", " test"
   @click "button:contains(Сохранить)", "td:contains(test rule test)"

ua.then "edit updated rule", ->
   @click "td:contains(test rule test) + td + td a", ".ui-dialog-title"

ua.then "delete created rule", ->
   @click "button:contains(Удалить)", "tr", (s) => 2 == @numberOf(s)

ua.then "go back to roles", ->
   @click "[href='#!role']", "td:contains(admin)"

ua.then "admin options", ->
   @click "tr:contains(admin) a:contains(Параметры)", "td:contains(pbx_id)"

test_create_update_delete ua, "option"

ua.then "go to users", ->
   @click "[href='#!user']", "td:contains(admin)"

ua.then "create new user", -> @click "#0", ".ui-dialog-title"
ua.then "fill admin role", ->
   @text "input[name=name]", "test"
   @text "input[name=role]", "admin"
   @wait ".ui-menu-item a:first"

ua.then "click on typeahead list", ->
   @click ".ui-menu-item a:first", "input[name=pbx_id]"

ua.then "save new user", ->
   @text "input[name=pbx_id]", "111"
   @text "input[name=list_id]", "222"
   @click "button:contains(Сохранить)", "td:contains(test)"

ua.then "edit new user", -> @click "tr:contains(test) button:contains(Править)", "input[name=pbx_id]"

ua.then "check new user", ->
   @ok "name", "test" == @val "input[name=name]"
   @ok "role", "admin" == @val "input[name=role]"
   @ok "option pbx_id", "111" == @val "input[name=pbx_id]"
   @ok "option list_id", "222" == @val "input[name=list_id]"
   @click "button:contains(Удалить)", "tr:contains(test)", (s) => ! @exists s

ua.then "fin", -> @exit()

ua.nextStep "http://localhost:3000"