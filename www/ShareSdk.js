var argscheck = require('cordova/argscheck'),
exec = require('cordova/exec');

var exports = {};

exports.share = function (message,success, error) {
  exec(success, error, "ShareSdk", "share", [message]);
};

module.exports = exports;

