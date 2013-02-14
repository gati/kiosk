###
	Main kiosk class that handles kiosk
	data and initial kiosk setup
###
class Kiosk extends Renderer
	
	constructor : () ->
		super()

	init : () =>
		@fetchKiosk()

	fetchKiosk : () =>

		# $.getJSON 'http://myurl.com?callback=?', (res) =>
		@setKioskData()

	setKioskData : (data) =>
		@data = {}
		@data.panels = []
		@render()

$(document).ready ->
	window.Kiosk = new Kiosk()
	window.Kiosk.init()
