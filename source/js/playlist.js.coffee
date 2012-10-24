class window.Playlist
  constructor: (uri) ->
    @app = window.app
    @object = @app.sp.core.getPlaylist(uri)

    @loadTracks()
    @el = $('<ol></ol>')
    @app.playlist = this

    @multiTracksPlaylist = new @app.models.Playlist()
    for track in @tracks
      @multiTracksPlaylist.add track
    console.log "tracks: ", @tracks

    @multiTracksPlayer = new @app.views.List @multiTracksPlaylist
    @multiTracksPlayer.track = null
    @multiTracksPlayer.context = @multiTracksPlaylist

  name: ->
    @object.name

  loadTracks: ->
    @tracks = []
    console.log "num tracks", @object.length
    for i in [0...@object.length]
      @tracks.push @app.models.Track.fromURI @object.getTrack(i).uri

  render: ->
    # for track in @tracks
    #   @el.append "<li>" + track.name + "</li>"
    @el.html @multiTracksPlayer.node
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
      @app.player.playTrack track.data.uri
      @renderCurrentTrack()

    startTime = new Date().getTime()
    secondsLeft = @app.threshold()
    refreshInterval = 1000

    @timeouts = []

    pauseTimer = =>
      if @app.pausing
        # keep track of how long it's pausing
        @timeouts.push setTimeout(pauseTimer, refreshInterval)
      else
        @timeouts.push(setTimeout playTimer, refreshInterval)

    playTimer = =>
      if secondsLeft > 0
        secondsLeft -= 1
        @displayTimer secondsLeft
        if @app.pausing
          # do something
          @timeouts.push setTimeout(pauseTimer, refreshInterval)
        else
          @timeouts.push setTimeout(playTimer, refreshInterval)
      else
        # skip to next song
        # skip song here
        @playNextTrack()
    
    @displayTimer secondsLeft
    @timeouts.push window.setTimeout(playTimer, refreshInterval)

  displayTimer: (secondsLeft) ->
    val = @app.threshold() - secondsLeft
    $('.dial').val(val).trigger('change')

  renderCurrentTrack: ->
    track = @tracks[@currentTrack]
    $("#current-track").html(track.name + ' by ' + track.data.album.artist.name)
    console.log "album cover", track.data.album.cover
    # display album art
    $('#album-art').attr('src', track.data.album.cover).show()
    # display time
    # play track
  reset: ->
    @app.player.playing = false
    for timeout in @timeouts
      clearTimeout timeout
    @timeouts = []

    # reset progress bar
    @tracks = []
    $('#album-art').attr('src', $('#album-art').data('original-src'))
    @displayTimer 0
