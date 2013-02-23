class SlideShow
	
	constructor: (params) ->
		@config = {}
		@$kiosk = $('[kiosk]')
		@$nav = $('nav[kiosk-nav]')
		@$navOptions = @$nav.find('.option')
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
				@updateNav(@index)
				return
			else
				@index++

			@slide(@translateWidth)
			@updateNav(@index)
		, @config.intervalSpeed

	slide : (x) =>
		@$kiosk.css('-webkit-transform' : 'translateX(-'+x+'px)')
		@translateWidth += @winWidth

	updateNav : (index) =>
		console.log(index)
		@$navOptions.removeClass('selected')
		@$navOptions.removeClass('flip')
		current = @$navOptions.eq(index-1)
		current.addClass('flip').addClass('selected')

window.SlideShow = SlideShow