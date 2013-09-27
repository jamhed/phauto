// Generated by CoffeeScript 1.6.2
var root;

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root.fn = function(ua) {
  ua.then("открываем страницу", function(uri) {
    return this.page.open(uri);
  });
  ua.then("подключаем к странице jquery", function() {
    var _this = this;
    return this.page.includeJs("/js/lib/jquery.js", function() {
      return _this.nextStep();
    });
  });
  ua.then("заполняем форму логина", function() {
    this.text("input[name='name']", "admin");
    this.text("input[name='password']", "admin");
    return this.click("input[type='submit']");
  });
  ua.then("ждем загрузки всех скриптов", function() {
    return this.wait("script[src^='/js/a/Source.js']");
  });
  return ua;
};
