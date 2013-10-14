exampleView = (text, init = null, cleanup = null) ->
  init = init || ->
  cleanup = cleanup || ->
  new Tutorial.ExampleView
    initAction: init
    cleanupAction: cleanup
    exampleText: text

highlightFunc = (selector) ->
  -> highlight(selector)

highlight = (selector) ->
  $(selector).css('outline', 'red solid 3px')

removeHighlightFunc = (selector) ->
  -> removeHighlight(selector)

removeHighlight = (selector) ->
  $(selector).css('outline', 'none')

clickFunc = (selector) ->
  -> click selector

click = (selector) ->
  doClick = ->
    $(selector).click()
  setTimeout doClick, 0

navigateFunc = (path) ->
  -> navigate path

navigate = (path) ->
  window.location.pathname = path

viewsForIndex = ->
  views = []
  views.push exampleView "At BibleRICH, we teach you scriptures with pictures."

  views.push exampleView(
    "We recommend you start by <strong>Teach</strong>ing <strong>Yourself</strong>
    how to memorize a certain topic or section of the Bible.",
    highlightFunc('#learn-link'),
    removeHighlightFunc('#learn-link'))

  clickLearn_highlightDaysOfCreation = ->
    click '#learn-link'
    highlight '#days-of-creation-link'

  views.push(exampleView(
      "You should start by learning <strong>The Days of Creation</strong>.",
      clickLearn_highlightDaysOfCreation,
      removeHighlightFunc('#days-of-creation-link')))

  views.push(exampleView(
    "Navigating to <strong>The Days of Creation</strong>",
    navigateFunc('/bible-highlights/genesis/chapter-1.html')))
  views

viewsForTeachYourself = ->
  views = []
  views.push(exampleView(
    "The <strong>Teach Yourself</strong> section is where you can learn
    about what you want to memorize."))
  views.push exampleView(
    "The picture should aid your memory.",
    highlightFunc('#picture'),
    removeHighlightFunc('#picture'))
  views.push exampleView(
    "The text explains the memory aids in the picture.")
  views.push exampleView(
    "If you would like to listen, you can play this recording of the text.",
    highlightFunc('audio'),
    removeHighlightFunc('audio'))
  views.push exampleView(
    """When you're done <strong>Teach</strong>ing <strong>Yourself</strong>
    what you want to memorize, you can <strong>Quiz Yourself</strong>.""",
    highlightFunc('#quiz-link'),
    removeHighlightFunc('#quiz-link'))

  clickQuiz_highlightDays = ->
    click '#quiz-link'
    highlight '#days-flashcards'
  views.push exampleView(
    "We'll go to <strong>The Days of Creation</strong> flashcards.",
    clickQuiz_highlightDays,
    removeHighlightFunc('#days-flashcards'))
  views.push exampleView(
    "Navigating to <strong>The Days of Creation</strong> flashcards.",
    navigateFunc('/bible-highlights/review/genesis/chapter-1.html'))

  views

viewsForQuizYourself = ->
  views = []
  views.push exampleView(
    "The <strong>Quiz Yourself</strong> section lets you test your
    memory with flashcards.")
  views.push exampleView(
    "You can navigate through the cards with the arrow buttons.",
    highlightFunc('.prev, .next'),
    removeHighlightFunc('.prev, .next'))
  removeHighlight_clickFlip = ->
    removeHighlight '.flip'
    click '.flip'
  views.push exampleView(
    "You can flip cards with this button.",
    highlightFunc('.flip'),
    removeHighlight_clickFlip)
  views.push exampleView(
    "And you can shuffle using this button.",
    highlightFunc('.shuffle'),
    removeHighlightFunc('.shuffle'))
  views.push exampleView("Now you know the basics! Learn the Days of Creation,
    or, if you'd really like to, feel free to explore the rest of the site!")
  views

exampleViews = (page) ->
  switch page
    when 'index'
      viewsForIndex()
    when 'teach-yourself'
      viewsForTeachYourself()
    when 'quiz-yourself'
      viewsForQuizYourself()

window.Tutorial =
  initPage: (page) ->
    tutorialView = new Tutorial.TutorialView
      exampleViews: exampleViews(page)
    tutorialView.render()
