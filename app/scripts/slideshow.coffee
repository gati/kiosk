class SlideShow
	
	constructor: (params) ->
		
		#default configuration
		config = {
			intervalSpeed : 5000,
			debug : false
		}

		if params.debug is true
			params.intervalSpeed = 5000

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
		@sceneTranslateWidth = @$kioskWidth - (@winWidth * 2)
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
		    	@sceneTranslateWidth = Math.floor((@$kioskWidth + Math.floor(@winWidth * 2)) / @index)
		    	@slide(@translateWidth, @sceneTranslateWidth)
		    	return

		@slideshowInterval = setInterval () =>
			if @index is @count
				@translateWidth = 0
				@sceneTranslateWidth = @$kioskWidth - (@winWidth * 2)
				@$characters.hide()
				@slide(0, @sceneTranslateWidth)
				@index = 1
				@updateNav(@index)
				return
			else
				@index++

			@slide(@translateWidth, @sceneTranslateWidth)
			@updateNav(@index)
		, @config.intervalSpeed

	slide : (kioskPosition, scenePosition) =>
		@$kiosk.css('-webkit-transform' : 'translateX(-'+kioskPosition+'px)')
		@$skyline.css('-webkit-transform' : 'translateX(-'+kioskPosition+'px)')
		@$fromLeft.css('-webkit-transform', 'translateX(-'+scenePosition+'px)')
		

		@translateWidth += @winWidth
		@sceneTranslateWidth -= @winWidth
		setTimeout () =>
			@$characters.show()
		, 2000

	updateNav : (index) =>
		@$navOptions.removeClass('selected')
		@$navOptions.find('.icon').removeClass('selected')
		current = @$navOptions.eq(index-1)
		current.addClass('selected')

window.SlideShow = SlideShow