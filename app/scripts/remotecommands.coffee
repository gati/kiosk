Pusher.log = (message) =>
    if window.console && window.console.log
        window.console.log(message)

WEB_SOCKET_DEBUG = true

pusher = new Pusher('4fd2f56ec46d4df00991')
channel = pusher.subscribe('kiosk')

# reload the kiosk
channel.bind 'reload', (data) =>
    if data is true
        window.location.reload(true)