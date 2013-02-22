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
		url = 'http://vast-ocean-9515.herokuapp.com/festivals/api/v1/presentation/?venue=1&format=jsonp&callback=?'
		$.getJSON url, (res) =>
			@render(res)
		
$(document).ready ->
	window.Kiosk = new Kiosk()
	window.Kiosk.init()
