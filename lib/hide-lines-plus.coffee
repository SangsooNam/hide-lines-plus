{CompositeDisposable} = require 'atom'

module.exports =
  configDefaults:
    patterns: ['^>']
    useCustomMarker: true

  config:
    patterns:
      type: 'array'
      default: ['^>']
      description: 'Comma separated list of regex patterns to hide'
      items:
        type: 'string'
    useCustomMarker:
      type: 'boolean'
      default: true
      description: 'Use \'Show >\' marker instead of the default one'

  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'hide-lines-plus:hide': => @hide()
      'hide-lines-plus:show': => @show()
      'hide-lines-plus:toggle': => @toggle()

    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      foldsLayer = editor.displayLayer.foldsMarkerLayer

      # Handle current folds.
      markers = foldsLayer.getMarkers()
      @decorateFold(editor, marker) for marker in markers

      # Subscribe to all future folds.
      @subscriptions.add foldsLayer.onDidCreateMarker (marker) =>
        @decorateFold editor, marker

  deactivate: ->
    @subscriptions.dispose()

  decorateFold: (editor, marker) ->
    if atom.config.get('hide-lines-plus.useCustomMarker')
      editor.decorateMarker(marker, { type: 'line', class: 'hide-lines-plus' })

  hide: ->
    rowsToHide = []
    patterns = atom.config.get('hide-lines-plus.patterns')
    editor = atom.workspace.getActiveTextEditor()

    for pattern in patterns
      editor.scan new RegExp(pattern, 'g'), (m) ->
        row = m.range.end.row

        if rowsToHide.indexOf(row) == -1
          rowsToHide.push(row)

    sets = []

    for row in rowsToHide
      lastSet = sets[sets.length - 1]
      if !lastSet || lastSet[1] + 1 != row
        sets.push([row, row])
      else
        lastSet[1] = row

    for set in sets
      editor.foldBufferRange([[set[0], 0], [set[1], editor.lineTextForBufferRow(set[1]).length]])

  show: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.unfoldAll()
    @markerIds = []

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    anyFolded = false

    for row in [0..editor.getLastBufferRow()]
       if editor.isFoldedAtBufferRow(row)
         anyFolded = true
         break
    if anyFolded
      @show()
    else
      @hide()
