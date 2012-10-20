console.log "Loading Shotify!"
jQuery.event.props.push("dataTransfer")

# Initialize Spotify API
if typeof(getSpotifyApi) == 'function'
  sp = getSpotifyApi(1)
  models = sp.require("sp://import/scripts/api/models")
  views = sp.require("sp://import/scripts/api/views")
  ui = sp.require("sp://import/scripts/ui")
  player = models.player
  library = models.library
  application = models.application
  playerImage = new views.Player()

class Playlist
  constructor: (selector) ->
    @drop = $(selector)
    @drop.bind 'dragenter', (event) =>
      console.log "Drag Enter"
      @drop.addClass('over')

    @drop.bind 'dragover', (event) =>
      event.preventDefault()
      # Required so the drop is accepted.
      event.dataTransfer.dropEffect = 'copy'
      false

    @drop.bind 'dragleave', (event) =>
      console.log "Drag Leave"
      @drop.removeClass('over')

    @drop.bind 'drop', (event) =>
      console.log "DROP THE BEAT"
      uri = event.dataTransfer.getData('Text')
      console.log "DROPPED: "+uri
      @drop.removeClass('over')
      this.setupPlaylist(uri)

    console.log "Created playlist "+@drop.prop('nodeName')+'#'+@drop.prop('id')

  setupPlaylist: (uri) ->
    models.Playlist.fromURI(uri, @handlePlaylistLoaded)

  handlePlaylistLoaded: (playlist) =>
    console.log('Playlist loaded', playlist.name);
    @drop.find("h4").html(playlist.name)

$ ->
  window.playlist = new Playlist("#playlist_drop")