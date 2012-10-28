class window.Setting
  constructor: (selector) ->
    console.log "setting"
    @app = window.app
    @el = $(selector)

    $(".setting-buttons > a").click -> $(this).addClass('btn-info active').siblings().removeClass('btn-info active')

    $('a#random-off').click => @app.player.shuffle = false
    $('a#random-on').click  => @app.player.shuffle = true
    $('a#interval-first').click => @interval = "first"
    $('a#interval-middle').click => @interval = "middle"
    $('a#interval-last').click => @interval = "last"
    $('a#interval-random').click => @interval = "random"

    @app.player.observe @app.models.EVENT.CHANGE, (event) =>
      console.log "settings detect player changes", event.data.shuffle, event
      if event.data.shuffle
        @setRandom @app.player.shuffle

    @setRandom @app.player.shuffle
    @setInterval "first"

  trackURIWithSeek: (track) ->
    offset = @getTrackPlayOffset track
    temp = track.uri + @offsetToMinSec(offset)
    console.log temp
    temp

  offsetToMinSec: (offset) ->
    min = Math.floor(offset/60000)
    sec = Math.floor((offset%60000)/1000)
    "#" + (if min < 10 then ('0' + min) else min) + ":" + (if sec < 10 then ('0' + sec) else sec)

  setRandom: (flag) ->
    if flag 
      elem = '#random-on'
    else
      elem = '#random-off'

    $(elem).click()

  setInterval: (value) ->
    $("#interval-" + value).click()

  getTrackPlayOffset: (track) ->
    duration    = track.duration / 1000 # in seconds
    sampleDuration = @app.threshold() # in seconds
    offset = 0
    console.log "checking interval", @app.setting.interval
    switch @app.setting.interval
      when "first" then offset = 0
      when "last" then offset = duration - sampleDuration
      when "middle" then offset = (duration - sampleDuration) / 2
      when "random"
        max = duration - sampleDuration
        offset = Math.floor Math.random() * max
    console.log "returning offset", offset
    Math.floor(offset) * 1000
