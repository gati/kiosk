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
			debug : false,
			scheduleRefreshInterval : 1800000, # 30 minutes
			updatesRefreshInterval : 300000 # 5 minutes 
		}

		@config = $.extend({}, config, params)
		
	start : () =>
		@fetchKioskSlides()
	
	getURLParameter : (name) =>
		return decodeURIComponent( (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[null,""])[1] )

	fetchKioskSlides : () =>
		url = "#{@baseURI}/presentation/#{@venueID}?format=jsonp&callback=?"
		$.getJSON url, (res) =>
			console.log('Transition time : ',res.transition_time * 1000+'ms')
			# set the transition speed
			@transitionSpeed = res.transition_time * 1000 ? 30000
			@render(res)
			@fetchScheduleData()
			@fetchMapData()
			@fetchAnnouncementsData()
			@setRefreshIntervals()
		, (err) =>
			# try again
			@fetchKioskSlides()

	fetchScheduleData : () =>
		
		range = moment()
		start = if @config.debug then '2013-03-10T14:00:00' else range.format('YYYY-MM-DDTHH:mm:ss')
		end = if @config.debug then '2013-03-10T09:00:00' else range.add('hours', 4).format('YYYY-MM-DDTHH:mm:ss')
		url = "#{@baseURI}/scheduled-event/?room__venue=#{@venueID}&start__gte="+end+"&start__lte="+start+"&format=jsonp&callback=?"
		# fetch schedule
		schedule = {}
		schedule.events = []
		group = {}
		$.getJSON url, (data) =>
			console.log('Raw schedule data : ', data)
			events = data.objects
			for i in [0...events.length]
				event = events[i]
				start = moment(event.start)
				end = moment(event.end).format('h:mma')
				format = start.format('h:mm a')
				hr = start.hours()

				event.end = end
				event.key = start.unix()

				if not group[format]
					group[format] = []

				group[format].push(event)
				
			for j of group
				schedule.events.push({
					prettyTime : j,
					key : group[j][0].key
					events : group[j]
				})

			# sort by start time
			schedule.events = _(schedule.events).sortBy (event) =>
				return event.key

			console.log('Transformed schedule data : ',schedule)
			@renderSchedule(schedule)
		, (err) =>
			console.log err

	fetchMapData : () =>
		url = "#{@baseURI}/venue/#{@venueID}/?format=jsonp&callback=?"
		#fetch maps
		$.getJSON url, (data) =>
			@renderMaps(data)

	fetchAnnouncementsData : () =>
		range = moment()
		start = range.format('YYYY-MM-DDTHH:mm:ss')
		url = "#{@baseURI}/announcement/?venues=#{@venueID}&start__lte=#{start}&end__gte=#{start}&format=jsonp&callback=?"
		
		#fetch announcements
		$.getJSON url, (data) =>
			console.log('Announcements : ', data)
			filteredData = {}
			filteredData.objects = []
			firstPublished = false

			#filter out announcements that aren't published
			if data.objects.length
				for i in [0..data.objects.length-1]
					object = data.objects[i]
					if object.status is 'published'
						formatted = moment(object.start).format('h:mma dddd MMMM D')
						object.key = moment(object.start).unix()
						object.start = formatted
						filteredData.objects.push(object)
			
			# sort by start time
			filteredData.objects = _(filteredData.objects).sortBy (event) =>
				return event.key

			filteredData.objects.reverse()

			# set the first announcement's display to a bigger bubble
			if data.objects.length
				filteredData.objects[0].main = true

			@renderAnnouncements(filteredData)

	setRefreshIntervals : () =>
		@setScheduleInterval()
		@setUpdatesInterval()

	setScheduleInterval : () =>
		setInterval () =>
			#refresh the schedule
			@fetchScheduleData()
		, @config.scheduleRefreshInterval

	setUpdatesInterval : () =>
		setInterval () =>
			#refresh the updates
			@fetchAnnouncementsData()
		, @config.updatesRefreshInterval

$(document).ready ->
	window.Kiosk = new Kiosk({
		debug : false
	})

	window.Kiosk.start()
