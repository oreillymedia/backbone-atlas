Atlas = (url, token) ->

  root = @
  @url    = url
  @token  = token

  # Sync
  # --------------------------------------------------------

  #@sync = (method, model, options) ->
  #  extendedOptions = undefined
  #  extendedOptions = _.extend(
  #    beforeSend: (xhr) ->
  #      xhr.setRequestHeader "PRIVATE-TOKEN", root.token if root.token
  #  , options)
  #  Backbone.sync method, model, extendedOptions
#
  #@Model = Backbone.Model.extend(sync: @sync)
  #@Collection = Backbone.Collection.extend(sync: @sync)

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
    comparator: (b) -> -b.get('created_at')
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