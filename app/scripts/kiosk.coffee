###
	Main kiosk class that handles kiosk
	data and initial kiosk setup
###
class Kiosk extends Renderer
	
	constructor : () ->
		super()

	init : () =>
		@fetchKiosk()

	fetchKiosk : () =>

		# $.getJSON 'http://myurl.com?callback=?', (res) =>
		@setKioskData()

	setKioskData : (data) =>
		# DUMMY DATA
		data = {
			id : 'AGDASG12512t32egsdh124gsdh21',
			panels : [
				{
					type : 'url',
					url : 'http://mattnull.com'
				},
				{
					type : 'url',
					url : 'http://goodattheinternet.com'
				},
				{
					type : 'url',
					url : 'http://zachherring.com'
				},
				{
					type : 'event'
				}
			]
		}
		@data = {}
		@data.id = data.id
		@data.panels = data.panels
		@render()

$(document).ready ->
	window.Kiosk = new Kiosk()
	window.Kiosk.init()
