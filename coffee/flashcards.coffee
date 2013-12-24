window.Flashcards = Flashcards =
  init: (pageUrl, options = {}, cardData = null) ->
    if _.isArray options
      cardData = options
      options = {}

    router = new Flashcards.Router(cardData: cardData, cardOptions: options)
    Backbone.history.start
      root: pageUrl
    router.start()

Flashcards.Router = class Router extends Backbone.Router
  routes:
    "card/:id": "showCard"

  initialize: ({cardData, cardOptions}) ->
    @numCards = cardData.length
    @ids = [1..@numCards]
    @navigationView = new NavigationView
      cardData: cardData
      imageFirst: !!cardOptions.imageFirst
      el: document.getElementById('flashcards')
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

  initialize: ({@cardData, @imageFirst}) ->

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
      @view = @cardViews[index] = new CardView @cardData[index], @imageFirst
    @$el.prepend(@view.render())


Flashcards.CardView = class CardView extends Backbone.View
  className: 'card'

  events:
    'click': 'toggle'

  initialize: (data, @frontFirst = false) ->
    @back = @buildBack(data)
    @front = @buildFront(data)
    @showingFront = @frontFirst
    @$el.append @getNotShown(!@showingFront)

  buildBack: (data) ->
    if data.text
      $("<div>#{data.text}</div>")
    else if data.front
      $("<div>#{data.front}</div>")
    else
      throw new Error 'No data for the front of the card.'

  buildFront: (data) ->
    if data.img
      $("<img src='/img/flashcards/#{data.img}' alt='click to see other side'></img>")
    else if data.back
      $("<div>#{data.back}</div>")
    else
      throw new Error 'No data for the back of the card.'

  getNotShown: (showingFront) ->
    if showingFront
      @back
    else
      @front

  getDirection: (showingFront) ->
    if showingFront
      'rl'
    else
      'lr'

  toggle: =>
    @$el.flip
      direction: @getDirection(@showingFront)
      speed: 200
      content: @getNotShown(@showingFront)[0] # flip acts funny when passed a jQuery element list
      color: 'white'

    @showingFront = !@showingFront

  render: ->
    @el

  remove: ->
    @$el.detach()

