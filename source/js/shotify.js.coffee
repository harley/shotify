#= require playlist_drop
#= require playlist

console.log "Loading Shotify!"
jQuery.event.props.push("dataTransfer")

window.app = 
  threshold: ->
    $(".num_seconds").val()
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
    if app.playlist
      $('.main-container').addClass('playing')
      # app.playlist.hide()
      app.playlist.playRandom()
      # hide play button
      $(this).hide()
      # show progress bar
      $('.progress').show()
      $('#drop-another').show()
      $('.dial').trigger('configure', {'max': $('.num_seconds').val()})
    else
      alert "Error: Playlist not loaded yet!"
    return false
  $('#drop-another').click ->
    # display playlist-dropper and hide current tracks info
    $('.main-container').removeClass('after-drop playing').addClass('before-drop')
    $(this).hide()
    app.playlist.reset()

  # store original img src
  $('#album-art').data('original-src', $('#album-art').attr('src'))
  $(".dial").knob
    'max': app.threshold()
    'readOnly': true
    'width': 100
    'height': 100
  $(".knob").knob()
