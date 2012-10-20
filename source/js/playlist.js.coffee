class window.Playlist
  constructor: (uri) ->
    @app = window.app
    @object = @app.sp.core.getPlaylist(uri)

    @loadTracks()
    @el = $('<ul></ul>')
    console.log 'set el as ', @el

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
