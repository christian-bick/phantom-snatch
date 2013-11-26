var system = require('system');

if (system.args.length < 2) {
  console.log('Missing arguments.');
  phantom.exit();
}

var server = require('webserver').create();
var port = parseInt(system.args[1]);

var parse_qs = function(s) {
    var queryString = {};
    var a = document.createElement('a');
    a.href = s;
    a.search.replace(
        new RegExp('([^?=&]+)(=([^&]*))?', 'g'),
        function($0, $1, $2, $3) { queryString[$1] = $3; }
    );
    return queryString;
};

var now = function() {
  return new Date().getTime();
}

var renderHtml = function(url, respond) {
  var page = require('webpage').create();
  page.settings.loadImages = false;
  page.settings.localToRemoteUrlAccessEnabled = true;
  page.open(url, function (status) {
    if (status == 'success') {
    
      var timeout = 5000,
          checkInterval = 250,
          start = new Date().getTime(),
          ready = false,
          content = null;
        
      var interval = setInterval(function() {
        var timedOut = (now() - start) > timeout;
        if ( !timedOut && !ready ) {
          ready = page.evaluate(function () {
            var body = document.getElementsByTagName('body')[0];
            return body.getAttribute('data-status') == 'ready';
          });
        } else {
          var content = page.evaluate(function () {
            return document.getElementsByTagName('html')[0].outerHTML;
          });
          respond(200, content);
          if (ready) {
            console.log('Successfully taken snapshot of ' + url);
          } else {
            console.warn('Ready-condition not met for ' + url);
            console.log('Taken snapshot after timeout of ' + url);
          }
          page.close();
          clearInterval(interval);
        }
      }, checkInterval);
      
    } else {
      var errorMsg = 'Failed to take snapshot of ' + url;
      console.log(errorMsg);
      respond(502, errorMsg);
    }
  });
};

server.listen(port, function (request, response) {
  
  // We have to be provided with the origin protocol and host 
  var protocol = request.headers['X-Forwarded-Proto'];
  var host = request.headers['X-Forwarded-Host'];
  
  if (!protocol || !host) {
    response.statusCode = 400;
    response.write('Requests must contain headers "X-Forwarded-Host" and "X-Forwarded-Proto" to evaluate base url', 'utf-8');
    response.close();
    return;
  }
  var urlPrefix = protocol + '://' + host;
  
  // We have to be provided with an escaped fragment
  var route = parse_qs(request.url)._escaped_fragment_;
  if (!route) {
    response.statusCode = 400;
    response.write('Requests must contain search parameter "_escaped_fragment_" to evaluate pretty url', 'utf-8');
    response.close();
    return;
  }
  
  var url = urlPrefix
      + request.url.slice(1, request.url.indexOf('?'))
      + '#!' + decodeURIComponent(route);
      
    var respond = function(status, content) {
    response.statusCode = status;
    response.setHeader('Content-Type', 'text/html; charset=utf-8');
    response.setHeader('Content-Length', -1);
    response.write(content, 'utf-8');
    response.close();
  }
  
  renderHtml(url, respond);
});

console.log('Listening on ' + port + '...');
