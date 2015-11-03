var argscheck = require('cordova/argscheck'),
exec = require('cordova/exec');

var exports = {};

exports.show = function (success, error) {
  exec(success, error, "GuidePage", "show", []);
};


module.exports = exports;

