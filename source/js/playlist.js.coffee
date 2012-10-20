class window.Playlist
  constructor: (app, sp_playlist) ->
    @app = app
    @sp_playlist = sp_playlist
    @sp_track_uris = sp_playlist.data.all()
    @loadTracks()
  name: ->
    @sp_playlist.name
  loadTracks: ->
    @tracks = []
    for uri in @sp_track_uris
      console.log "loading track", uri
      @app.models.Track.fromURI uri, (track) =>
        console.log "appending ", track.name
        @tracks.push track

