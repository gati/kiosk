###
	Main kiosk class that handles kiosk
	data and initial kiosk setup
###
class Kiosk extends Renderer
	
	constructor : (params) ->
		super()
		@baseURI = 'http://vast-ocean-9515.herokuapp.com/festivals/api/v1'
		@venueID = @getURLParameter('venue')
		config = {
			debug : false
		}

		@config = $.extend({}, config, params)
		
	init : () =>
		@fetchKioskSlides()
	
	getURLParameter : (name) =>
		return decodeURIComponent( (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[null,""])[1] )

	fetchKioskSlides : () =>
		url = "#{@baseURI}/presentation/?room__venue=#{@venueID}&format=jsonp&callback=?"
		$.getJSON url, (res) =>
			@renderSlides(res)
			@fetchScheduleData()
			@fetchMapData()
			@fetchAnnouncementsData()

	fetchScheduleData : () =>
		console.log(@venueID)
		range = moment()
		start = if @config.debug then '2013-03-10T14:00:00' else range.format('YYYY-MM-DDTHH:mm:ss')
		end = if @config.debug then '2013-03-10T12:00:00' else range.add('hours', 4).format('YYYY-MM-DDTHH:mm:ss')
		url = "#{@baseURI}/scheduled-event/?room__venue=#{@venueID}&start__gte="+end+"&start__lte="+start+"&format=jsonp&callback=?"
		# fetch schedule
		schedule = {}
		schedule.events = []
		group = {}
		$.getJSON url, (data) =>
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
		url = "#{@baseURI}/venue/#{@venueID}/?format=jsonp&callback=?"
		#fetch maps
		$.getJSON url, (data) =>
			@renderMaps(data)

	fetchAnnouncementsData : () =>
		url = "#{@baseURI}/announcement/?room__venue=#{@venueID}&format=jsonp&callback=?"
		#fetch announcements
		$.getJSON url, (data) =>
			console.log('ANNOUNCEMENTS', data)
			filteredData = {}
			filteredData.objects = []
			firstPublished = false
			#filter out announcements that aren't published
			for i in [0..data.objects.length-1]
				object = data.objects[i]
				if object.status is 'published'
					if not firstPublished
						object.main = true
					formatted = moment(object.start).format('h:mma dddd MMMM D')
					object.start = formatted
					filteredData.objects.push(object)
					firstPublished = true
			console.log 'FILTERED', filteredData
			@renderAnnouncements(filteredData)

$(document).ready ->
	window.Kiosk = new Kiosk({
		debug : true
	})
	window.Kiosk.init()
