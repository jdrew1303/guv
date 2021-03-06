
chai = require 'chai' if not chai
yaml = require 'js-yaml'
guv = require '..'
fs = require 'fs'
path = require 'path'

scaleTest = (test) ->
  describe "#{test.name}", () ->

    it test.expect, () ->
      cfg = guv.config.parse test.config
      role = (test.role or '*')
      actual = guv.scale.scaleWithHistory cfg[role], role, test.history, test.current, test.state.messages
      actual = actual.next
      chai.expect(actual).to.equal test.result


describe 'Scaling', () ->
  try
    tests = yaml.safeLoad fs.readFileSync (path.join __dirname, 'scaletests.yaml'), 'utf-8'
  catch e
    console.log 'ERROR parsing test file'
    console.log e
    throw e
  tests.forEach (test) ->
    test.history = [] if not test.history
    test.current = null if not test.current
    scaleTest test
