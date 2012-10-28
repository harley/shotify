class window.Playlist
  constructor: (uri) ->
    @app = window.app
    # TODO verify if fromURI is safe to use, otherwise use getPlaylist
    # @object = @app.sp.core.getPlaylist(uri)
    @sp_playlist = @app.models.Playlist.fromURI uri
    console.log @sp_playlist
    @object = @sp_playlist.data

    @loadTracks()
    @el = $('<ol></ol>')
    @app.playlist = this

    # @multiTracksPlaylist = new @app.models.Playlist()
    # for track in @tracks
    #   @multiTracksPlaylist.add track
    # console.log "tracks: ", @tracks
    @multiTracksPlaylist = @sp_playlist

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

  startPlaying: ->
    @playRandom true
  playRandom: (firstTime) ->
    @currentTrack = 0
    @playCurrentTrack(firstTime)
  playNextTrack: ->
    @currentTrack += 1
    @playCurrentTrack()
  playCurrentTrack: (firstTime = false) ->
    # display track name
    track = @tracks[@currentTrack]
    if track
      console.log "looking at track", @currentTrack, track.uri
      # TODO allow playing from other position, not just from start
      if firstTime
        @app.player.play @multiTracksPlaylist.uri, @multiTracksPlaylist.uri, @currentTrack
      else
        # to take advantage of shuffle feature if used
        @app.player.next()

      track = @app.player.track
      @renderCurrentTrack()

    startTime = new Date().getTime()
    @app.secondsLeft = @app.threshold()
    refreshInterval = 1000

    @timeouts = []

    pauseTimer = =>
      if @app.pausing
        # keep track of how long it's pausing
        @timeouts.push setTimeout(pauseTimer, refreshInterval)
      else
        @timeouts.push setTimeout(playTimer, refreshInterval)

    playTimer = =>
      if @app.secondsLeft > 0
        @app.secondsLeft -= 1
        @displayTimer @app.secondsLeft
        if @app.pausing
          # do something
          @timeouts.push setTimeout(pauseTimer, refreshInterval)
        else
          @timeouts.push setTimeout(playTimer, refreshInterval)
        #displayTimer
      else
        # skip to next song
        # skip song here
        @playNextTrack()
    
    @displayTimer @app.secondsLeft
    @timeouts.push window.setTimeout(playTimer, refreshInterval)

  displayTimer: (seconds) ->
    val = @app.threshold() - seconds
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
