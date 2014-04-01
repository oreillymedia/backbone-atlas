Atlas = (url, token) ->

  root = @
  @url    = url
  @token  = token

  # Sync
  # --------------------------------------------------------
  
  @Model = Backbone.Model.extend()
  @Collection = Backbone.Collection.extend()

  # Builds
  # --------------------------------------------------------

  @Build = @Model.extend(
    backboneClass: "Build"

    toJSON: ->
      json = _.clone(@attributes)
      json.status = _.map(json.status, (bf) ->
        bf.isQueued = bf.status == "queued"
        bf.isWorking = bf.status == "working"
        bf.isCompleted = bf.status == "completed"
        bf.isFailed = bf.status == "failed"
        bf
      )
      json
  )

  @Builds = @Collection.extend(
    url: -> "#{root.url}/builds"
    model: root.Build

    # Initialize collection.
    #
    # options.project - String value of username/project to load builds from
    #
    # Returns nothing.    
    initialize: (models, options = {}) ->
      if !options.project then throw root.Builds.ERROR_INIT_NO_PROJECT
      @project = options.project

    # Custom fetch function. Used to add project info in fetch call.
    #
    # Returns nothing.
    fetch: (options) ->
      root.Collection.prototype.fetch.call(this, _.extend(data: project: @project, options))

    # Custom create function. Used to add project info to create call
    create: (attributes, options) ->
      attributes.project = @project
      root.Collection.prototype.create.call(this, attributes, options)
    
    comparator: (b) -> -b.get('created_at')
  ,
    ERROR_INIT_NO_PROJECT : "You have to initialize this collection with a project path"
  )

  # Tokens
  # --------------------------------------------------------

  @Token = @Model.extend()

  @Tokens = @Collection.extend(
    model: root.Token
    url: -> "#{root.url}/tokens"
  )

  # RegistrationCodes (Admin Only)
  # --------------------------------------------------------

  @RegistrationCode = @Model.extend(
    url: ->
      url = "#{root.url}/registration_codes"
      url += "/" +  this.get("id") if this.get("id")
      return url
  )

  @RegistrationCodes = @Collection.extend
    url: -> "#{root.url}/registration_codes"
    model: root.RegistrationCode


  # LoginRegistrationCodes
  # --------------------------------------------------------

  @LoginRegistrationCode = @Model.extend(
    url: ->
      url = "#{root.url}/login_registration_codes"
      url += "/" +  this.get("code") if this.get("id")
      return url
  )

  @LoginRegistrationCodes = @Collection.extend(
    url: "#{root.url}/login_registration_codes"
    model: root.LoginRegistrationCode
  )

  # Collaborators
  # --------------------------------------------------------

  @Collaborator = @Model.extend(

    destroy: (options) ->
      extra_data = {}
      if @collection
        extra_data[@collection.collaborator_type] = @collection.collaborator_id
      root.Model.prototype.destroy.call(this, _.extend(data: extra_data, options))
  )

  @Collaborators = @Collection.extend(

    model: root.Collaborator
    url: -> "#{root.url}/collaborators"

    initialize: (models, options = {}) ->
      if !options.project && !options.group then throw root.Collaborators.ERROR_INIT
      if options.project?
        @collaborator_type = "project"
        @collaborator_id = options.project
      else
        @collaborator_type = "group"
        @collaborator_id = options.group

    # Custom create function. Used to add project or group info to create call
    fetch: (options) ->
      extra_data = {}
      extra_data[@collaborator_type] = @collaborator_id
      root.Collection.prototype.fetch.call(this, _.extend(data: extra_data, options))

    # Custom create function. Used to add project or group info to create call
    create: (attributes, options) ->
      attributes[@collaborator_type] = @collaborator_id
      root.Collection.prototype.create.call(this, attributes, options)
  ,
    ERROR_INIT : "You have to initialize this collection with a project path or group id"
  )

  # Initialize
  # --------------------------------------------------------

  return @

window.Atlas = Atlas