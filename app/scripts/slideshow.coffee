class SlideShow
	
	constructor: (params) ->
		
		#default configuration
		config = {
			intervalSpeed : 5000,
			debug : false
		}

		@$kiosk = $('[kiosk]')
		@$nav = $('nav[kiosk-nav]')
		@$navOptions = @$nav.find('.option')

		#adjust z-index of options
		len = @$navOptions.length
		@$navOptions.each () ->
		  $(this).css('zIndex',len)
		  len--

		@$panels = @$kiosk.find('.slide')
		@count = @$panels.length
		@winWidth = $(window).innerWidth()
		@translateWidth = @winWidth
		@index = 1
		@config = $.extend({}, @config, params)
		
	start : () =>
		if @config.debug?
	    	hash = window.location.hash.slice(1)
	    	slideIndex = parseInt(hash) || false
		    if slideIndex
		    	@updateNav(slideIndex)
		    	@index = slideIndex - 1
		    	@translateWidth = @winWidth * @index
		    	@slide(@translateWidth)
		    	return

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
		@$navOptions.removeClass('selected')
		@$navOptions.removeClass('flip')
		current = @$navOptions.eq(index-1)
		current.addClass('flip').addClass('selected')

window.SlideShow = SlideShow