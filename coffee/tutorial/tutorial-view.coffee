Tutorial = window.Tutorial || {}

Tutorial.TutorialView = class TutorialView extends Backbone.View
  events:
    "click .cancel": "close"
    "click .next": "next"

  initialize: ({@exampleViews}) ->
    @viewIndex = 0

  template: """
    <div class="modal hide fade" id='tutorial'>
      <div class="modal-header">
        <button type="button" class="close cancel" aria-hidden="true">&times;</button>
        <h3>Tutorial</h3>
      </div>
      <div class="modal-body">
      </div>
      <div class="modal-footer">
        <a href="#" class="cancel btn">Cancel Tutorial</a>
        <a href="#" class="btn btn-primary next">Next</a>
      </div>
    </div>
  """

  render: ->
    @$modal = $(@template)
    @$el.append(@$modal)
    @renderExample()
    # Must append to body otherwise stuff doesn't wire up correctly
    $('body').append(@el)
    @$modal.modal backdrop: false

  renderExample: ->
    if @currView
      @currView.cleanup()
      @$currHtml.remove()
    @currView = @exampleViews[@viewIndex]
    @$currHtml = $(@currView.render())
    @$el.find('.modal-body').append(@$currHtml)
    @currView.init()

  cleanupExample: ->
    @currView.cleanup()

  close: ->
    @trigger 'dismiss-tutorial'
    @$modal.modal 'hide'

  next: ->
    if @viewIndex < @exampleViews.length - 1
      @viewIndex++
      @renderExample()
    else
      @cleanupExample()
      @$modal.modal 'hide'

