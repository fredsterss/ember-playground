App = Ember.Application.create
  LOG_TRANSITIONS: true

App.Router.map ->
  # define routes with default settings
  @resource "about"
  @resource "posts", ->
    # post model changes depending on what url,
    # nesting it nests templates using {{outlet}}
    @resource "post", path: ':post_id'

App.PostsRoute = Ember.Route.extend
  model: ->
    posts

# refreshing page drops all state, so need
# to explicitly bind a model to the post route
# in order to deeplink. Params is populated from
# the route.
App.PostRoute = Ember.Route.extend
  # Can replace these models with AJAX requests. To
  # remain async it supports .promises (ie. $.getJSON('url').then( massage data ))
  model: (params) ->
    posts.findBy 'id', params.post_id

App.PostController = Ember.ObjectController.extend
  isEditing: false,
  # map to action helpers, switches internal cache
  actions:
    edit: ->
      @set 'isEditing', true
    
    doneEditing: ->
      @set 'isEditing', false


# Define a helper to be accessible from handlebars
Ember.Handlebars.helper 'format-date', (date) ->
  moment(date).fromNow()

# Output markdown
showdown = new Showdown.converter()
Ember.Handlebars.helper 'format-markdown', (input) ->
  # SafeString opts out of HTML escaping
  new Handlebars.SafeString(showdown.makeHtml(input))

# Dummy data
posts = [
  id: "1"
  title: "Rails is Omakase"
  author:
    name: "d2h"

  date: new Date("12-27-2012")
  excerpt: "There are lots of à la carte software environments in this world. Places where in order to eat, you must first carefully look over the menu of options to order exactly what you want."
  body: "I want this for my ORM, I want that for my template language, and let's finish it off with this routing library. Of course, you're going to have to know what you want, and you'll rarely have your horizon expanded if you always order the same thing, but there it is. It's a very popular way of consuming software.\n\nRails is not that. Rails is omakase."
,
  id: "2"
  title: "The Parley Letter"
  author:
    name: "d2h"

  date: new Date("12-24-2012")
  excerpt: "My [appearance on the Ruby Rogues podcast](http://rubyrogues.com/056-rr-david-heinemeier-hansson/) recently came up for discussion again on the private Parley mailing list."
  body: "A long list of topics were raised and I took a time to ramble at large about all of them at once. Apologies for not taking the time to be more succinct, but at least each topic has a header so you can skip stuff you don't care about.\n\n### Maintainability\n\nIt's simply not true to say that I don't care about maintainability. I still work on the oldest Rails app in the world."
]