console.log "Loading Shotify!"
jQuery.event.props.push("dataTransfer")

window.app = 
  setup: ->
    # Initialize Spotify API
    if typeof(getSpotifyApi) == 'function'
      @sp = getSpotifyApi(1)
      @models = @sp.require("sp://import/scripts/api/models")
      @views = @sp.require("sp://import/scripts/api/views")
      @ui = @sp.require("sp://import/scripts/ui")
      @player = @models.player
      @library = @models.library
      @application = @models.application
      # @playerImage = new views.Player()
    else
      alert "Sorry -- only work in Spotify"
  setCurrentPlaylist: (playlist) ->
    @playlist.current = playlist
    console.log "setting current playlist to be ", @playlist.current
    @playlist.current.updatePlaylistView()
    console.log @playlist.current.data.all()

window.app.setup()

class PlaylistDrop
  # bind events
  constructor: (selector) ->
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
    window.app.models.Playlist.fromURI uri, (playlist) =>
      @currentPlaylist = playlist
      @updatePlaylistView()

  updatePlaylistView: ->
    # update playlist name
    $("#current-playlist").html(@currentPlaylist.name)
    # display Play button
    $("#play-button").show()
    # update items in playlist

  handlePlaylistLoaded: (playlist) =>
    window.app.setCurrentPlaylist playlist

$ ->
  # init playlist drop
  window.app.playlist = new PlaylistDrop("#playlist_drop")
