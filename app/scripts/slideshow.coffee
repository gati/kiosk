class SlideShow extends App
	constructor: (params) ->
		super()
		@config.intervalSpeed = params.intervalSpeed or 5000
		
	start : () ->
		# setInterval () ->
		# 	#interval
		# , @config.intervalSpeed