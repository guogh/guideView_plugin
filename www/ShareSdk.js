var argscheck = require('cordova/argscheck'),
exec = require('cordova/exec');

var exports = {};

exports.share = function (title,text,imgUrl,url,success, error) {
  exec(success, error, "ShareSdk", "share", [title,text,imgUrl,url]);
};

module.exports = exports;

