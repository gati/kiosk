class SlideShow
	constructor: (params) ->
		@config = {}
		@$kiosk = $('[kiosk]')
		@$panels = @$kiosk.find('.slide')
		@count = @$panels.length
		@translateHeight = $(window).innerHeight()
		@index = 1
		@config.intervalSpeed = params.intervalSpeed or 5000
		
	start : () =>

		@slideshowInterval = setInterval () =>
			if @index is @count
				@translateHeight = $(window).outerHeight()
				@slide(0)
				@index = 1
				return
			else
				@index++

			@slide(@translateHeight)
		, @config.intervalSpeed

	slide : (y) =>
		@$kiosk.css('-webkit-transform' : 'translateY(-'+y+'px)')
		@translateHeight += y


window.SlideShow = SlideShow