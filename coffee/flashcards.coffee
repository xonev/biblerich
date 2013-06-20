window.Flashcards = Flashcards =
  init: (pageUrl, cardData) ->
    router = new Flashcards.Router(cardData: cardData)
    Backbone.history.start
      root: pageUrl
    router.start()

Flashcards.Router = class Router extends Backbone.Router
  routes:
    "card/:id": "showCard"

  initialize: ({cardData}) ->
    @numCards = cardData.length
    @navigationView = new NavigationView(cardData: cardData, el: document.getElementById('flashcards'))
    @navigationView.on 'previous', => @changeRoute(-1)
    @navigationView.on 'next', => @changeRoute(1)

  showCard: (id) ->
    @index = id - 1
    @navigationView.show(@index)

  changeRoute: (amount) ->
    newIndex = @index + amount
    newIndex = if newIndex >= 0 then newIndex else newIndex % @numCards + @numCards
    @index = newIndex % @numCards
    @navigate("card/#{@index + 1}", trigger: true)

  start: ->
    @firstCard()

  firstCard: ->
    @navigate('card/1', trigger: true)

Flashcards.NavigationView = class NavigationView extends Backbone.View
  cardViews: []

  events:
    'click .prev': 'previous'
    'click .next': 'next'
    'click .flip': 'flip'

  initialize: ({@cardData}) ->

  previous: ->
    @trigger('previous')

  next: ->
    @trigger('next')

  flip: ->
    @view?.toggle()

  show: (index) ->
    @view?.remove()
    if @cardViews[index]
      @view = @cardViews[index]
    else if @cardData.length > index
      @view = @cardViews[index] = new CardView @cardData[index]
    @$el.prepend(@view.render())


Flashcards.CardView = class CardView extends Backbone.View
  className: 'card'

  events:
    'click': 'toggle'

  initialize: ({@img, @text}) ->
    @imgElement = $("<img src='/img/flashcards/#{@img}' alt='click to see answer'></img>")
    @$el.append(@imgElement)
    @showingImage = true

  toggle: =>
    if @showingImage
      element = @textElement ||= $("<p>#{@text}</p>")
      direction = 'rl'
    else
      element = @imgElement
      direction = 'lr'

    @$el.flip
      direction: direction
      speed: 200
      content: element[0] # flip acts funny when passed a jQuery element list
      color: 'white'

    @showingImage = !@showingImage

  render: ->
    @el

  remove: ->
    @$el.detach()

