'use strict'

tripPlannerApp.filter 'prettyTime', ->
  (seconds) ->
    pretty = switch
      when seconds >= 108000 then Math.round(seconds / 86400, 1) + ' days'
      when seconds >= 3600 then Math.round(seconds / 3600, 1) + ' hours'
      when seconds >= 60 then Math.round(seconds / 60) + ' minutes'
      else seconds + ' seconds'
