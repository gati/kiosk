use Rack::Static,  :urls => ["/styles", "/scripts", "/images"], :root => "dist"
run Rack::Directory.new("dist")

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('dist/index.html', File::RDONLY)
  ]
}