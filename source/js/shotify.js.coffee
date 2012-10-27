#= require playlist_drop
#= require playlist

jQuery.event.props.push("dataTransfer")

window.app = 
  threshold: ->
    $(".num_seconds").val()
  setup: ->
    # Initialize Spotify API
    if typeof(getSpotifyApi) == 'function'
      @sp = getSpotifyApi(1)
      @models = @sp.require "sp://import/scripts/api/models"
      @views = @sp.require "sp://import/scripts/api/views"
      @player = @models.player

      @models.player.observe @models.EVENT.CHANGE, (event) =>
        # updatePageWithTrackDetails() if event.data.curtrack
        if @models.player.playing
          @pausing = false
        else
          @pausing = true
      @models.player.playing = false

      # Handle items 'dropped' on app icon
      @models.application.observe @models.EVENT.LINKSCHANGED, (event) =>
        if event.links.length > 0
          @playlist_drop.setupPlaylist event.links[0]

    else
      console.log "Sorry -- only work in Spotify"
    @playlist_drop = new PlaylistDrop("#playlist_drop")

$ ->
  app.setup()
  $('#play-button').click (e) ->
    e.preventDefault()
    if app.playlist
      $('.main-container').removeClass('after-drop').addClass('playing')
      # app.playlist.hide()
      app.playlist.playRandom()
      # hide play button
      $(this).hide()
      # set the threshold before starting
      $('.dial').trigger('configure', {'max': $('.num_seconds').val()})
    else
      alert "Error: Playlist not loaded yet!"
    false
  $('#drop-another').click ->
    # display playlist-dropper and hide current tracks info
    $('.main-container').removeClass('after-drop playing').addClass('before-drop')
    app.playlist.reset()
    false

  # store original img src
  $('#album-art').data('original-src', $('#album-art').attr('src'))
  $(".dial").knob
    'max': app.threshold()
    'readOnly': true
    'width': 200
    'height': 200
  $(".knob").knob()
