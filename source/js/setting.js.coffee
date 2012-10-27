class window.Setting
  constructor: (selector) ->
    console.log "setting"
    @app = window.app
    @el = $(selector)
    @setRandom @app.player.shuffle

    $('a#random-off').click  =>
      console.log "random off"
      @app.player.shuffle = false
      @setRandom false

    $('a#random-on').click  =>
      console.log "random on"
      @app.player.shuffle = true
      @setRandom true


    @app.player.observe @app.models.EVENT.CHANGE, (event) =>
      # console.log "settings detect player changes", event.data.shuffle, event
      if event.data.shuffle
        @setRandom @app.player.shuffle

  setRandom: (flag) ->
    # console.log "setRandom", flag
    @random = flag
    if flag 
      elem = '#random-on'
    else
      elem = '#random-off'

    $(elem).addClass('btn-info active').siblings().removeClass('btn-info active')

