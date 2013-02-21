
class Renderer

	constructor: () ->
		@templates = {}
		@$kiosk = $('[kiosk]')

		self = @

		#store the handlebars templates
		$('[template]').each (e) ->
			el = $(this)
			self.templates[el.attr('template')] = Handlebars.compile(el.html())
	
	render : () =>

		#store kiosk id in DOM
		@$kiosk.attr('kiosk', @data.id)

		#render the panels
		slides = @data.slides
		for i in [0...slides.length]
			@$kiosk.append @templates[slides[i].type](slides[i])

		@attachEvents()
		@resizeSlides()

		#start the slideshow
		@slideshow = new SlideShow({
			intervalSpeed : 5000
		})

		@slideshow.start()

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
