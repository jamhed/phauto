UAJQ = require("./UAJQ.js").class
login = require("./login.js").fn 
keep_page = require("./keep-page.js").fn

ua = keep_page login new UAJQ

ua.nextStep "http://localhost:3000/login"
