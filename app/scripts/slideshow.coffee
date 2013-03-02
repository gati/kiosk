class SlideShow
	
	constructor: (params) ->
		
		#default configuration
		config = {
			intervalSpeed : 5000,
			debug : false
		}

		@$kiosk = $('[kiosk]')
		@$scene = $('#scene')
		@$skyline = @$scene.find('.skyline')
		@$crowd = @$scene.find('.crowd')
		@$characters = @$scene.find('.characters')
		@$fromLeft = @$scene.find('.from-left')
		@$scene.show();

		@$nav = $('nav[kiosk-nav]')
		@$navOptions = @$nav.find('.option')
		@characterPosition = 0

		#adjust z-index of options
		len = @$navOptions.length
		@$navOptions.each () ->
		  $(this).css('zIndex',len)
		  len--

		@$kioskWidth = @$kiosk.outerWidth()
		@$panels = @$kiosk.find('.slide')
		@count = @$panels.length
		@winWidth = $(window).innerWidth()
		@translateWidth = @winWidth
		@sceneTranslateWidth = @$kioskWidth - @winWidth
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
				@sceneTranslateWidth = @$kioskWidth - @winWidth
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
		@$skyline.css('-webkit-transform' : 'translateX(-'+x+'px)')
		# @$characters.css('-webkit-transform' : 'translateX('+@translateWidth+'px)')
		@$fromLeft.css('-webkit-transform', 'translateX(-'+(@sceneTranslateWidth)+'px)')
		@translateWidth += @winWidth
		@sceneTranslateWidth -= @winWidth
		# @moveCharacters()

	moveCharacters : () =>
		# console.log @characterPosition
		# @$characters.css('-webkit-transform' : 'translateX('+@winWidth+'px)')
		# @characterPosition += @winWidth 

	updateNav : (index) =>
		@$navOptions.removeClass('selected')
		@$navOptions.find('.icon').removeClass('selected')
		current = @$navOptions.eq(index-1)
		current.addClass('selected')

window.SlideShow = SlideShow