class window.PlaylistDrop
  # bind events
  constructor: (selector) ->
    @app = window.app
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

    $(document).on 'playlistLoaded', =>
      console.log "receiving playlistLoaded"
      @updatePlaylistView()

    console.log "Created playlist " + @el.prop('nodeName') + '#' + @el.prop('id')

  # provide callback to set current playlist
  watchDropping: (uri) ->
    @currentPlaylist = new window.Playlist(uri)
    console.log "setting currentPlaylist = ", @currentPlaylist
    @updatePlaylistView()

  updatePlaylistView: ->
    if @currentPlaylist
      console.log 'updatePlaylistView on ', @currentPlaylist
      # update playlist name
      $("#current-playlist").html(@currentPlaylist.name())
      # display Play button
      $("#play-button").show()
      # update items in playlist
      $("#tracks-container").html(@currentPlaylist.render().el)
