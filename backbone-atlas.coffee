Atlas = (url, token) ->

  root = @
  @url    = url
  @token  = token

  # Sync
  # --------------------------------------------------------

  @sync = (method, model, options) ->
    if root.token
      options = {} unless options
      options.data = {} unless options.data
      options.data.auth_token = root.token
    Backbone.sync method, model, options
  
  @Model = Backbone.Model.extend(sync: @sync)
  @Collection = Backbone.Collection.extend(sync: @sync)

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
    
    comparator: (b) -> -b.get('created_at')
  ,
    ERROR_INIT_NO_PROJECT : "You have to initialize this collection with a project path in options"
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
      url = "/api/login_registration_codes"
      url += "/" +  this.get("code") if this.get("id")
      return url
  )

  @LoginRegistrationCodes = @Collection.extend(
    url: "/api/login_registration_codes"
    model: root.LoginRegistrationCode
  )

  # Initialize
  # --------------------------------------------------------

  return @

window.Atlas = Atlas