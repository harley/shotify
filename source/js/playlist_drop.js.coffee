class window.PlaylistDrop
  # bind events
  constructor: (selector) ->
    @app = window.app
    @el = $(selector)
    @el.on 'dragenter', (event) =>
      @el.addClass('over')
      @el.find('h4').html('Ready?')

    @el.on 'dragover', (event) =>
      event.preventDefault()
      # Required so the drop is accepted.
      event.dataTransfer.dropEffect = 'copy'
      false

    @el.on 'dragleave', (event) =>
      console.log "Drag Leave"
      @el.removeClass('over')
      @el.find('h4').html('Drop Playlist Here')

    @el.on 'drop', (event) =>
      uri = event.dataTransfer.getData('Text')
      console.log "DROPPED: " + uri
      @el.removeClass('over')
      $('.container').removeClass('before-drop').addClass('after-drop')
      @watchDropping(uri)
      @el.find('h4').html('Drop Playlist Here')

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
      $("#current-playlist").html('Playlist: ' + @currentPlaylist.name())
      # display Play button
      $("#play-button").show()
      # update items in playlist
      $("#tracks-container").html(@currentPlaylist.render().el)
