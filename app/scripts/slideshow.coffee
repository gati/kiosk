class SlideShow
	
	constructor: (params) ->
		@config = {}
		@$kiosk = $('[kiosk]')
		@$panels = @$kiosk.find('.slide')
		@count = @$panels.length
		@winWidth = $(window).innerWidth()
		@translateWidth = @winWidth
		@index = 1
		@config.intervalSpeed = params.intervalSpeed or 5000
		
	start : () =>

		@slideshowInterval = setInterval () =>
			if @index is @count
				@translateWidth = 0
				@slide(0)
				@index = 1
				return
			else
				@index++

			@slide(@translateWidth)
		, @config.intervalSpeed

	slide : (x) =>
		@$kiosk.css('-webkit-transform' : 'translateX(-'+x+'px)')
		@translateWidth += @winWidth

window.SlideShow = SlideShow