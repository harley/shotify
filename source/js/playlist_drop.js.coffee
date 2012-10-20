class window.PlaylistDrop
  # bind events
  constructor: (app, selector) ->
    @app = app
    @el = $(selector)
    @el.bind 'dragenter', (event) =>
      console.log "Drag Enter"
      @el.addClass('over')

    @el.bind 'dragover', (event) =>
      event.preventDefault()
      # Required so the drop is accepted.
      event.dataTransfer.dropEffect = 'copy'
      false

    @el.bind 'dragleave', (event) =>
      console.log "Drag Leave"
      @el.removeClass('over')

    @el.bind 'drop', (event) =>
      console.log "DROP THE BEAT"
      uri = event.dataTransfer.getData('Text')
      console.log "DROPPED: "+uri
      @el.removeClass('over')
      @watchDropping(uri)

    console.log "Created playlist " + @el.prop('nodeName') + '#' + @el.prop('id')

  # provide callback to set current playlist
  watchDropping: (uri) ->
    @app.models.Playlist.fromURI uri, (sp_playlist) =>
      @currentPlaylist = new window.Playlist(app, sp_playlist)
      @updatePlaylistView()

  updatePlaylistView: ->
    # update playlist name
    $("#current-playlist").html(@currentPlaylist.name())
    # display Play button
    $("#play-button").show()
    # update items in playlist
