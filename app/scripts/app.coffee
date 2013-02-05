class App
	
	constructor : () ->
		@win = $(window)
		@panelContainer = $('#panels')
		@panels = @panelContainer.find('.panel')
		@adjustPanels()
		@showPanels()

	adjustPanels : () ->
		containerWidth = 0
		@panels.each () ->
			el = $(@)
			containerWidth += el.outerWidth(true)

		@panelContainer.width(containerWidth)

	showPanels: () ->
		@panelContainer.addClass('visible')

window.App = App

new App()