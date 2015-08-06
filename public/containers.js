var Containers = (function(){
  var template = "# Your instance is ready!<br /> $ telnet {ip} {port}";
  var bindEvents = function(instance) {
    $('#getContainer').on('click', function(){
      instance.create();
      return false;
    });
  }

  function Module(docker_ip) {
    this.IP = docker_ip;
    bindEvents(this);
  }

  Module.prototype.list = function(){
    var containers = $.ajax({
      url: '/ps.json',
      type: 'GET',
      async: false
    }).responseJSON;

    return containers;
  }

  Module.prototype.create = function(){
    var _this = this;

    $('#responseHolder').removeClass('hidden');
    $('#responseHolder').html('Creating...');

    $.ajax({
      url: '/create.json',
      dataType: 'json',
      type: 'POST',
      success: function(data) {
        var port = data.ports;
        var output = template.replace('{ip}', _this.IP)
          .replace('{port}', port);

        $('#responseHolder').html(output);
      }
    });
  }

  return Module;
})();
