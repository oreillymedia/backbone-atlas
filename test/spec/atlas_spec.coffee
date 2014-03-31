# Atlas Specs
#
# In these tests, results from the "test/canned" folder will be served as API responses.
# If you want to check that a specific URL was called, you can use the AJAX helpers:
#
#   spyOnAjax()
#   model.fetch()
#   expect(lastAjaxCall().args[0].type).toEqual("GET")
#   expect(lastAjaxCall().args[0].url).toEqual("www.runemadsen.com/user")
#
# Remember that the AJAX calls are actually being made, so to assert something on the response,
# you have to use Jasmine's asynchronous helpers:
#
#   model.fetch()
#   waitsFor(->
#     return model.id == 1
#   , "never loaded", 2000
#   )
#   runs(-> console.log "Done!")
#
# The AJAX helpers can of course be mixes with Jasmine's asynchronous helpers, as seen in the tests
# below.
#

ajaxTimeout = 1000
token = "abcdefg"
url = "http://127.0.0.1:5001"

describe("Atlas", ->

  atlas = null

  beforeEach(->
    atlas = new Atlas(url, token)
  )

  # Helpers
  # ----------------------------------------------------------------

  spyOnAjax = ->
    spyOn(Backbone, "ajax").and.callThrough()

  lastAjaxCall = ->
    Backbone.ajax.calls.mostRecent()

  lastAjaxCallData = ->
    d = Backbone.ajax.calls.mostRecent().args[0].data || {}
    if _.isString(d) then JSON.parse(d) else d

  # Atlas
  # ----------------------------------------------------------------

  describe("Atlas", ->

    it("should initialize with url", ->
      atlas = new Atlas(url)
      expect(atlas.url).toBe(url)
    )
  )

  # Atlas.Build
  # ----------------------------------------------------------------

  describe("Build", ->

    describe("#initialize", ->
      
      it("should put status flags in json output", ->
        build = new atlas.Build(
          status : [
            format : "pdf"
            status : "queued"
          ]
        )
        json = build.toJSON()
        expect(json.status[0].isQueued).toBe(true)
        expect(json.status[0].isWorking).toBe(false)
        expect(json.status[0].isCompleted).toBe(false)
        expect(json.status[0].isFailed).toBe(false)
      )
    )
  )

  describe("Builds", ->

    describe("#initialize", ->
      it("should throw error if no project path", ->
        expect(-> new atlas.Builds()).toThrow(atlas.Builds.ERROR_INIT_NO_PROJECT);
      )
    )

    describe("#fetch", ->
      it("should add project data to call", ->
        builds = new atlas.Builds([], project:"user/project")
        spyOnAjax()
        builds.fetch()
        expect(lastAjaxCall().args[0].type).toEqual("GET")
        expect(lastAjaxCall().args[0].url).toEqual(url + "/builds")
        expect(lastAjaxCallData()).not.toBe(undefined)
        expect(lastAjaxCallData().project).toBe("user/project")
      )
    )

    describe("#create", ->
      it("should add project data to call", ->
        builds = new atlas.Builds([], project:"user/project")
        spyOnAjax()
        builds.create(
          formats:"pdf,epub"
          branch:"master"
        )
        expect(lastAjaxCall().args[0].type).toEqual("POST")
        expect(lastAjaxCall().args[0].url).toEqual(url + "/builds")
        expect(lastAjaxCallData()).not.toBe(undefined)
        expect(lastAjaxCallData().project).toBe("user/project")
      )
    )

  )

  # Atlas.Collaborators
  # ----------------------------------------------------------------

  describe("Collaborators", ->
  
    describe("#fetch", ->
      
      it("should fetch pending invites for group", (done) ->
        collection = new atlas.Collaborators([], group: 1)
        collection.fetch(success: -> 
          expect(collection.length).toEqual(2)
          expect(collection.first().get("group")).toEqual("1")
          done()
        )
      )
  
      it("should fetch pending invites for project", (done) ->
        collection = new atlas.Collaborators([], project: "user/project")
        collection.fetch(success: -> 
          expect(collection.length).toEqual(2)
          expect(collection.first().get("project")).toEqual("user/project")
          done()
        )
      )
    )
  )
  
  describe("#create", ->
    
    it("should create collaborator for group", ->
      collection = new atlas.Collaborators([], group:1)
      spyOnAjax()
      collection.create(
        email: "first@user.com"
        permission_level: 40
        group_name: "somegroup"
      )
      expect(lastAjaxCall().args[0].type).toEqual("POST")
      expect(lastAjaxCall().args[0].url).toEqual(url + "/collaborators")
      expect(lastAjaxCallData()).not.toBe(undefined)
      expect(lastAjaxCallData().group).toBe(1)
      expect(lastAjaxCallData().group_name).toEqual("somegroup")
      expect(lastAjaxCallData().email).toEqual("first@user.com")
      expect(lastAjaxCallData().permission_level).toEqual(40)
    )
  
    it("should create collaborator for project", ->
      collection = new atlas.Collaborators([], project:"user/project")
      spyOnAjax()
      collection.create(
        email: "first@user.com"
        permission_level: 40
      )
      expect(lastAjaxCall().args[0].type).toEqual("POST")
      expect(lastAjaxCall().args[0].url).toEqual(url + "/collaborators")
      expect(lastAjaxCallData()).not.toBe(undefined)
      expect(lastAjaxCallData().project).toEqual("user/project")
      expect(lastAjaxCallData().email).toEqual("first@user.com")
      expect(lastAjaxCallData().permission_level).toEqual(40)
    )
  )
)