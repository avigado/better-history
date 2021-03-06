Fixtures = require '../fixtures/range_sanitizer_fixtures'

describe "BH.Workers.RangeSanitizer", ->
  beforeEach ->
    @visits = []
    @rangeSanitizer = new BH.Workers.RangeSanitizer()

  it "returns as many results as found", ->
    options =
      startTime: new Date("December 5, 2011 0:00")
      endTime: new Date("December 5, 2011 23:59")

    visits = Fixtures.lotsOfVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)
    expect(sanitizedVisits.length).toEqual(150)

  describe "Additional properties", ->
    it "sets a property called location to be equal to the url", ->
      options =
        startTime: new Date("October 1, 2010")
        endTime: new Date("October 14, 2010")

      visits = Fixtures.variousVisits()
      sanitizedVisits = @rangeSanitizer.run(visits, options)
      expect(sanitizedVisits[0].location).toEqual 'bread.com'

  describe "Removing script tags", ->
    it "removes any script tags in the title and url", ->
      options =
        startTime: new Date("June 1, 2010")
        endTime: new Date("October 14, 2011")

      visits = Fixtures.visitsWithScriptTag()
      sanitizedVisits = @rangeSanitizer.run(visits, options)

      expect(sanitizedVisits[0].title).toEqual("testalert(\"yo\")")
      expect(sanitizedVisits[1].location).toEqual("yahoo.comalert(\"yo\")")

  it "orders the matched results by lastVisitTime", ->
    options =
      startTime: new Date("June 1, 2010")
      endTime: new Date("October 14, 2011")

    visits = Fixtures.outOfOrderVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)

    titles = _.pluck(sanitizedVisits, 'title')
    expect(titles).toEqual ['biking tips', 'amatuer candling making', 'Great camping']

  it "matches results by checking if the date falls between the searched ranges", ->
    options =
      startTime: new Date("October 1, 2010")
      endTime: new Date("October 14, 2010")

    visits = Fixtures.variousVisits()
    sanitizedVisits = @rangeSanitizer.run(visits, options)

    titles = _.pluck(sanitizedVisits, 'title')
    expect(titles).toEqual ['bread making', 'Baking tips']
