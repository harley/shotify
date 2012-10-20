#= require playlist_drop
#= require playlist

console.log "Loading Shotify!"
jQuery.event.props.push("dataTransfer")

window.app = 
  setup: ->
    app.threshold = 6 # number of seconds to play each track
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
      # init playlist drop

      @models.player.observe @models.EVENT.CHANGE, (event) =>
        # updatePageWithTrackDetails() if event.data.curtrack
        if @models.player.playing
          @pausing = false
        else
          @pausing = true
      @models.player.playing = false
    else
      console.log "Sorry -- only work in Spotify"
    @playlist_drop = new PlaylistDrop("#playlist_drop")

$ ->
  app.setup()
  $('#play-button').click ->
    console.log "clicking, playlist = ", app.playlist
    if app.playlist
      # app.playlist.hide()
      app.playlist.playRandom()
    else
      alert "Error: Playlist not loaded yet!"
    $(this).hide()
    return false
