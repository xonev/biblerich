Tutorial = window.Tutorial || {}

Tutorial.ExampleView = class ExampleView extends Backbone.View
  initialize: ({@initAction, @cleanupAction, @exampleText}) ->

  init: ->
    @initAction()

  render: ->
    "<p>#{@exampleText}</p>"

  cleanup: ->
    @cleanupAction()
