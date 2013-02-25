
class Renderer

	constructor: () ->
		@templates = {}
		@$kiosk = $('[kiosk]')

		self = @

		#store the handlebars templates
		$('[template]').each (e) ->
			el = $(this)
			self.templates[el.attr('template')] = Handlebars.compile(el.html())
	
	renderSlides : (data) =>
		console.log 'TEMPLATES', @templates
		console.log 'RAW DATA', data

		@data = {}
		@data.id = data.objects[0].id
		@data.slides = data.objects[0].presentation_screens

		console.log('SLIDES', @data.slides)
		#store kiosk id in DOM
		@$kiosk.attr('kiosk', @data.id)

		#render the panels
		slides = @data.slides
		for i in [0...slides.length]
			slide = slides[i].screen
			@$kiosk.append @templates[slide.slide_type](slide)

		@attachEvents()
		@resizeSlides()

		#start the slideshow
		@slideshow = new SlideShow({
			intervalSpeed : 5000,
			debug : true
		})

		@slideshow.start()

	renderSchedule : (data) =>
		console.log('SCHEDULE', data)
		container = $('#events-list')
		container.html(@templates['events'](data))

	renderMaps : (data) =>
		console.log 'MAPS', data
		container = $('#maps')
		container.html(@templates['maps'](data))

	renderAnnouncements : (data) =>
		container = $('#announcement-bubbles')
		container.html(@templates['bubbles'](data))

	resizeSlides : () =>
		#force panels to be viewport height
		containerWidth = 0
		@$kiosk.find('.slide').each () ->
			el = $(this)
			el.height($(window).height())
			el.width($(window).outerWidth())
			containerWidth += el.outerWidth()

		@$kiosk.width(containerWidth)


	attachEvents : () =>
		doc = $(document)

window.Renderer = Renderer
