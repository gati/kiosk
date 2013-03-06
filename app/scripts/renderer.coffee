
class Renderer

	constructor: () ->
		@templates = {}
		@$kiosk = $('[kiosk]')
		@$scene = $('#scene')
		@$skyline = @$scene.find('.skyline')
		@$crowd = @$scene.find('.crowd')
		@$characters = @$scene.find('.characters')
		@$leftScene = @$scene.find('.from-left')
		@containerWidth = 0
		@transitionSpeed = 5000
		@winWidth = $(window).outerWidth()

		self = @

		#store the handlebars templates
		$('[template]').each (e) ->
			el = $(this)
			self.templates[el.attr('template')] = Handlebars.compile(el.html())
	
	render : (data) =>
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
		@adjustScene () =>
			#start the slideshow
			@slideshow = new SlideShow({
				intervalSpeed : @transitionSpeed,
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
		self = @
		#force panels to be viewport height
		@$kiosk.find('.slide').each () ->
			el = $(this)
			el.height($(window).height())
			el.width($(window).outerWidth())
			self.containerWidth += el.outerWidth()

		@$kiosk.width(@containerWidth)

	adjustScene : (callback) =>
		callback = callback or () =>
		# @$scene.width(@containerWidth)
		self = @
		# adjust each "scene" section to the kiosk width
		@$scene.find('section').width(self.containerWidth)
		# @$characters.height($(window).height())

		@$characters.find('.group').each () ->
			el = $(this)
			el.width($(window).outerWidth())

		@$leftScene.css('-webkit-transform', 'translateX(-'+(@containerWidth - $(window).outerWidth())+'px)')
		callback()

	attachEvents : () =>
		doc = $(document)

window.Renderer = Renderer
