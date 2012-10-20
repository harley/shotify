class window.Playlist
  constructor: (uri) ->
    @app = window.app
    @object = @app.sp.core.getPlaylist(uri)

    @loadTracks()
    @el = $('<ul></ul>')
    console.log 'set el as ', @el
    @app.playlist = this
    console.log "setting playlist as ", @app.playlist

  name: ->
    @object.name

  loadTracks: ->
    @tracks = []
    console.log "num tracks", @object.length
    for i in [0...@object.length]
      @tracks.push @object.getTrack(i)
    console.log @tracks

  render: ->
    console.log "rendering ", @tracks
    for track in @tracks
      @el.append "<li>" + track.name + "</li>"
    this
  playRandom: ->
    @currentTrack = 0
    @playCurrentTrack()
  playNextTrack: ->
    @currentTrack += 1
    @playCurrentTrack()
  playCurrentTrack: ->
    # display track name
    track = @tracks[@currentTrack]
    console.log "play track ", @currentTrack, track.uri
    @app.player.playTrack track.uri
    @renderCurrentTrack()

    startTime = new Date().getTime()
    timer = window.setInterval =>
      currTime = new Date().getTime()
      timePassed = (currTime - startTime) / 1000
      secondsLeft =  Math.ceil @app.threshold - timePassed

      if timePassed < @app.threshold
        $("#time-remaining").html('' + secondsLeft + " seconds left")
      else
        # threshold reached, next song
        console.log "time passed reached ", timePassed
        # skip song here
        window.clearInterval(timer)
        @playNextTrack()
    , 100

  renderCurrentTrack: ->
    track = @app.player.track
    $("#current-track").html(track.name + ' by ' + track.album.artist.name)
    console.log "album cover", track.album.cover
    # display album art
    $('#album-art').attr('src', track.album.cover).show()
    # display time
    # play track

