
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

		#render the panels
		for i in @data.panels
			@$kiosk.append @templates[@data.panels[i].type](@data)

		@attachEvents()

	attachEvents : () =>

window.Renderer = Renderer
