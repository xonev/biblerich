window.Flashcards = Flashcards =
  init: (pageUrl, cardData) ->
    router = new Flashcards.Router(cardData: cardData)
    Backbone.history.start
      root: pageUrl
    router.firstCard()

Flashcards.Router = class Router extends Backbone.Router
  routes:
    "card/:id": "showCard"

  cardViews: []

  initialize: ({@cardData}) ->

  showCard: (id) ->
    index = id - 1
    if @cardViews[index]
      view = @cardViews[index]
    else if @cardData.length > index
      view = @cardViews[index] = new CardView @cardData[index]
    $('body > div').append(view.render())

  firstCard: ->
    @navigate('card/1', trigger: true)

Flashcards.CardView = class CardView extends Backbone.View
  className: 'card'

  initialize: ({@img, @text}) ->
    @$el.append("<img src='/img/flashcards/#{@img}'></img>#{@text}")

  render: () ->
    @el
