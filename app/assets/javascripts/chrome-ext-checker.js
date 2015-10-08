var browserIsChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
var extension_id = 'jehhbmadcdlemapckoioiepfdneibacl';
var extension_link = 'https://chrome.google.com/webstore/detail/linkastor/jehhbmadcdlemapckoioiepfdneibacl'

function checkChromeExtension(callback){
  chrome.runtime.sendMessage(extension_id, {context: 'check_installed', question: 'Is the extension installed?'}, function(response){
    if (response) {
      callback(true);
    }
    else {
      callback(false);
    }
  });
};