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
    @ids = [1..@numCards]
    @navigationView = new NavigationView(cardData: cardData, el: document.getElementById('flashcards'))
    @navigationView.on 'previous', => @changeRoute(-1)
    @navigationView.on 'next', => @changeRoute(1)
    @navigationView.on 'shuffle', => @ids = _.shuffle(@ids)

  showCard: (id) ->
    @index = _.indexOf(@ids, parseInt(id))
    @navigationView.show(@ids[@index] - 1)

  changeRoute: (amount) ->
    newIndex = @index + amount
    newIndex = if newIndex >= 0 then newIndex else newIndex % @numCards + @numCards
    @index = newIndex % @numCards
    @navigate("card/#{@ids[@index]}", trigger: true)

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
    'click .shuffle': 'shuffle'

  initialize: ({@cardData}) ->

  previous: ->
    @trigger('previous')

  next: ->
    @trigger('next')

  flip: ->
    @view?.toggle()

  shuffle: ->
    @trigger('shuffle')

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
    @textElement = $("<p>#{@text}</p>")
    @$el.append(@textElement)
    @showingImage = false

  toggle: =>
    if @showingImage
      element = @textElement
      direction = 'rl'
    else
      @imgElement = $("<img src='/img/flashcards/#{@img}' alt='click to see answer'></img>")
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

