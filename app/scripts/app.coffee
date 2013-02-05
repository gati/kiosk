class App
	
	constructor : () ->
		@win = $(window)
		@panelContainer = $('#panels')
		@panels = @panelContainer.find('.panel')
		@adjustPanels()
		@showPanels()
		@attachEvents()

	adjustPanels : () ->
		containerWidth = 0
		@panels.each () ->
			el = $(@)
			containerWidth += el.outerWidth(true)

		@panelContainer.width(containerWidth)

	showPanels: () ->
		@panelContainer.addClass('visible')

	attachEvents : () ->
		#nav
		$('header nav').find('a').click () ->
			el = $(@)
			siblings = el.parent().siblings()
			el.parent().toggleClass('selected')
			siblings.removeClass('selected')

window.App = App

#for testing
new App()