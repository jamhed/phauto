UAJQ = require("UA/JQ.coffee")
login = require("login.coffee")
keep_page = require("keep-page.coffee")

ua = keep_page login new UAJQ

ua.nextStep "http://localhost:3000/login"
