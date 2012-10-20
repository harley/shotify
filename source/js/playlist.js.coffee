class window.Playlist
  constructor: (uri) ->
    @app = window.app
    @object = @app.sp.core.getPlaylist(uri)

    @loadTracks()
    @el = $('<ol></ol>')
    @app.playlist = this

  name: ->
    @object.name

  loadTracks: ->
    @tracks = []
    console.log "num tracks", @object.length
    for i in [0...@object.length]
      @tracks.push @object.getTrack(i)

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
    if track
      console.log "play track ", @currentTrack, track.uri
      # TODO allow playing from other position, not just from start
      @app.player.playTrack track.uri
      @renderCurrentTrack()

    startTime = new Date().getTime()
    secondsLeft = @app.threshold
    refreshInterval = 1000

    pauseTimer = =>
      if @app.pausing
        # keep track of how long it's pausing
        setTimeout pauseTimer, refreshInterval
      else
        setTimeout playTimer, refreshInterval

    playTimer = =>
      if secondsLeft > 0
        @displayTimer secondsLeft
        secondsLeft -= 1
        if @app.pausing
          # do something
          setTimeout pauseTimer, refreshInterval
        else
          setTimeout playTimer, refreshInterval
      else
        # skip to next song
        # skip song here
        @playNextTrack()
    
    window.setTimeout playTimer, refreshInterval

  displayTimer: (secondsLeft) ->
    $("#time-remaining > h4").html('' + secondsLeft + " seconds left")
    percentage = (@app.threshold - secondsLeft + 1) * 100.0 / @app.threshold
    $('.progress > .bar').css('width', percentage + '%')
  renderCurrentTrack: ->
    track = @tracks[@currentTrack]
    $("#current-track").html(track.name + ' by ' + track.album.artist.name)
    console.log "album cover", track.album.cover
    # display album art
    $('#album-art').attr('src', track.album.cover).show()
    # display time
    # play track

