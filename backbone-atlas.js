// Generated by CoffeeScript 1.6.3
(function() {
  var Atlas;

  Atlas = function(url, token) {
    var root;
    root = this;
    this.url = url;
    this.token = token;
    this.Model = Backbone.Model.extend();
    this.Collection = Backbone.Collection.extend();
    this.Build = this.Model.extend({
      backboneClass: "Build",
      toJSON: function() {
        var json;
        json = _.clone(this.attributes);
        json.status = _.map(json.status, function(bf) {
          bf.isQueued = bf.status === "queued";
          bf.isWorking = bf.status === "working";
          bf.isCompleted = bf.status === "completed";
          bf.isFailed = bf.status === "failed";
          return bf;
        });
        return json;
      }
    });
    this.Builds = this.Collection.extend({
      url: function() {
        return "" + root.url + "/builds";
      },
      model: root.Build,
      comparator: function(b) {
        return -b.get('created_at');
      }
    });
    this.Token = this.Model.extend();
    this.Tokens = this.Collection.extend({
      model: root.Token,
      url: function() {
        return "" + root.url + "/tokens";
      }
    });
    this.RegistrationCode = this.Model.extend({
      url: function() {
        url = "" + root.url + "/registration_codes";
        if (this.get("id")) {
          url += "/" + this.get("id");
        }
        return url;
      }
    });
    this.RegistrationCodes = this.Collection.extend({
      url: function() {
        return "" + root.url + "/registration_codes";
      },
      model: root.RegistrationCode
    });
    this.LoginRegistrationCode = this.Model.extend({
      url: function() {
        url = "/api/login_registration_codes";
        if (this.get("id")) {
          url += "/" + this.get("code");
        }
        return url;
      }
    });
    this.LoginRegistrationCodes = this.Collection.extend({
      url: "/api/login_registration_codes",
      model: root.LoginRegistrationCode
    });
    return this;
  };

  window.Atlas = Atlas;

}).call(this);
