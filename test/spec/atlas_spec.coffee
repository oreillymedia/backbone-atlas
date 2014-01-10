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
url = "http://127.0.0.1:5000"

describe("Atlas", ->

  atlas = null

  beforeEach(->
    atlas = new Atlas(url, token)
  )

  # Helpers
  # ----------------------------------------------------------------

  spyOnAjax = ->
    spyOn(Backbone, "ajax").andCallThrough()

  lastAjaxCall = ->
    Backbone.ajax.mostRecentCall

  lastAjaxCallData = ->
    d = Backbone.ajax.mostRecentCall.args[0].data || {}
    if _.isString(d) then JSON.parse(d) else d

  # Atlas
  # ----------------------------------------------------------------

  describe("Atlas", ->

    it("should initialize with url and token", ->
      expect(atlas.url).toBe(url)
      expect(atlas.token).toBe(token)
    )

    it("should initialize with url only", ->
      atlas = new Atlas(url)
      expect(atlas.url).toBe(url)
      expect(atlas.token).toBe(undefined)
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
)