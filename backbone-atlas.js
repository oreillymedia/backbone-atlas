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
      initialize: function(models, options) {
        if (options == null) {
          options = {};
        }
        if (!options.project) {
          throw root.Builds.ERROR_INIT_NO_PROJECT;
        }
        return this.project = options.project;
      },
      fetch: function(options) {
        return root.Collection.prototype.fetch.call(this, _.extend({
          data: {
            project: this.project
          }
        }, options));
      },
      create: function(attributes, options) {
        attributes.project = this.project;
        return root.Collection.prototype.create.call(this, attributes, options);
      },
      comparator: function(b) {
        return -b.get('created_at');
      }
    }, {
      ERROR_INIT_NO_PROJECT: "You have to initialize this collection with a project path"
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
        url = "" + root.url + "/login_registration_codes";
        if (this.get("id")) {
          url += "/" + this.get("code");
        }
        return url;
      }
    });
    this.LoginRegistrationCodes = this.Collection.extend({
      url: "" + root.url + "/login_registration_codes",
      model: root.LoginRegistrationCode
    });
    this.Collaborator = this.Model.extend({
      destroy: function(options) {
        var extra_data;
        extra_data = {};
        if (this.collection) {
          extra_data[this.collection.collaborator_type] = this.collection.collaborator_id;
        }
        return root.Model.prototype.destroy.call(this, _.extend({
          data: extra_data
        }, options));
      }
    });
    this.Collaborators = this.Collection.extend({
      model: root.Collaborator,
      url: function() {
        return "" + root.url + "/collaborators";
      },
      initialize: function(models, options) {
        if (options == null) {
          options = {};
        }
        if (!options.project && !options.group) {
          throw root.Collaborators.ERROR_INIT;
        }
        if (options.project != null) {
          this.collaborator_type = "project";
          return this.collaborator_id = options.project;
        } else {
          this.collaborator_type = "group";
          return this.collaborator_id = options.group;
        }
      },
      fetch: function(options) {
        var extra_data;
        extra_data = {};
        extra_data[this.collaborator_type] = this.collaborator_id;
        return root.Collection.prototype.fetch.call(this, _.extend({
          data: extra_data
        }, options));
      },
      create: function(attributes, options) {
        attributes[this.collaborator_type] = this.collaborator_id;
        return root.Collection.prototype.create.call(this, attributes, options);
      }
    }, {
      ERROR_INIT: "You have to initialize this collection with a project path or group id"
    });
    return this;
  };

  window.Atlas = Atlas;

}).call(this);
