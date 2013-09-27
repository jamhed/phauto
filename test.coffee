UAJQ = require("t/UA/JQ.coffee")
login = require("t/login.coffee")
keep_page = require("t/keep-page.coffee")

ua = keep_page login new UAJQ

ua.nextStep "http://localhost:3000/login"