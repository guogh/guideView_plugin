var argscheck = require('cordova/argscheck'),
exec = require('cordova/exec');

var exports = {};

exports.share = function (success, error) {
  exec(success, error, "ShareSdk", "share", []);
};

module.exports = exports;

