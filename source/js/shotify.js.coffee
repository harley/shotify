#= require playlist_drop
#= require playlist

console.log "Loading Shotify!"
jQuery.event.props.push("dataTransfer")

window.app = 
  setup: ->
    # Initialize Spotify API
    if typeof(getSpotifyApi) == 'function'
      @sp = getSpotifyApi(1)
      @models = @sp.require("sp://import/scripts/api/models")
      @views = @sp.require("sp://import/scripts/api/views")
      @ui = @sp.require("sp://import/scripts/ui")
      @player = @models.player
      @library = @models.library
      @application = @models.application
      # @playerImage = new views.Player()
    else
      alert "Sorry -- only work in Spotify"
    # init playlist drop
    @playlist_drop = new PlaylistDrop("#playlist_drop")

$ ->
  window.app.setup()
