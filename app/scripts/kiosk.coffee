###
	Main kiosk class that handles kiosk
	data and initial kiosk setup
###
class Kiosk extends Renderer
	
	constructor : () ->
		super()
		@baseURI = 'http://vast-ocean-9515.herokuapp.com/festivals/api/v1'
		@venueID = @getURLParameter('venue')
		
	init : () =>
		@fetchKioskSlides()
	
	getURLParameter : (name) =>
		return decodeURIComponent( (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[null,""])[1] )

	fetchKioskSlides : () =>
		url = "#{@baseURI}/presentation/?venue=#{@venueID}&format=jsonp&callback=?"
		$.getJSON url, (res) =>
			@renderSlides(res)
			@fetchScheduleData()
			@fetchMapData()

	fetchScheduleData : () =>
		scheduleUrl = "#{@baseURI}/scheduled-event/?venue=#{@venueID}&start__gte=2013-03-10T12:00:00&start__lte=2013-03-10T14:00:00&format=jsonp&callback=?"
		# fetch schedule
		schedule = {}
		schedule.events = []
		group = {}
		$.getJSON scheduleUrl, (data) =>
			events = data.objects
			for i in [0...events.length]
				event = events[i]
				t = moment(event.start)
				format = t.format('h:mma')
				hr = t.hours()

				if not group[format]
					group[format] = []

				event.key = hr
				group[format].push(event)

			for j of group
				schedule.events.push({
					prettyTime : j,
					events : group[j]
				})

			@renderSchedule(schedule)
		, (err) =>
			console.log err

	fetchMapData : () =>
		mapsUrl = "#{@baseURI}/venue/#{@venueID}/?format=jsonp&callback=?"
		#fetch maps
		$.getJSON mapsUrl, (data) =>
			@renderMaps(data)

	fetchAnnouncementsData : () =>


$(document).ready ->
	window.Kiosk = new Kiosk()
	window.Kiosk.init()
