
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
		for i in [0...@data.panels.length]
			@$kiosk.append @templates[@data.panels[i].type](@data.panels[i])

		@attachEvents()

		#start the slideshow
		@slideshow = new SlideShow({
			intervalSpeed : 3000
		})

		@slideshow.start()

	attachEvents : () =>

window.Renderer = Renderer
