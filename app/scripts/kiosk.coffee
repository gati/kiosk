###
	Main kiosk class that handles kiosk
	data and initial kiosk setup
###
class Kiosk extends Renderer
	
	constructor : () ->
		super()

	init : () =>
		@fetchKioskSlides()

	fetchKioskSlides : () =>
		url = 'http://vast-ocean-9515.herokuapp.com/festivals/api/v1/presentation/?venue=1&format=jsonp&callback=?'
		$.getJSON url, (res) =>
			@fetchSlideData(res)

	fetchSlideData : (data) =>

		slides = data.objects[0].presentation_screens
		@render(data)
		# for i in [0...slides.length]
		# 	slide = slides[i].screen 


		
$(document).ready ->
	window.Kiosk = new Kiosk()
	window.Kiosk.init()
