params = window.location.hash.substring(1).split ','

###
# load parameters
###
_baseUrl = params[0] ? '.'
_scriptType = params[1] ? 'js'
_dataType = params[2] ? 'csv'

###
# config
###
require.config
  baseUrl: _baseUrl
  paths: e2d3_default_paths
  config:
    text:
      useXhr: () -> true

requirejs.onError = (err) ->
  if err?.requireType == "fromtexteval"
    console.error err.message.split(/\n/)[0]
  else if err?.requireType == "timeout"
    # noop
  else
    throw err

###
# main routine
###
require ['domReady!', 'jquery', 'e2d3util', 'e2d3loader!main.' + _scriptType], (domReady, $, util, main) ->
  # set base uri
  $('#e2d3-base').attr('href', _baseUrl + '/')
  # load css, please ignore 404 error
  $('<link rel="stylesheet" type="text/css" href="main.css" >').appendTo 'head'

  _chart =
    if main?
      main $('#e2d3-chart-area').get(0), _baseUrl
    else
      {}

  $(window).on 'resize', (e) ->
    _chart.resize() if _chart.resize?

  window.debug =
    setupDebugConsole: () ->
      util.setupDebugConsole()
  window.chart =
    update: (data) ->
      _chart.update data if _chart.update?
    save: () ->
      _chart.save() if _chart.save?
