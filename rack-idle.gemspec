Gem::Specification.new do |s|
  s.name = "rack-idle"
  s.version = "0.1.0"
  s.summary = "Shutdown idle servers"
  s.description = "Automatically shutdown idle Rack servers."
  s.files = Dir["lib/**/*.rb"] << "README.rdoc"
  s.require_path = "lib"
  s.rdoc_options << "--main" << "README.rdoc" << "--charset" << "utf-8"
  s.extra_rdoc_files = ["README.rdoc"]
  s.author = "Matthew Sadler"
  s.email = "mat@sourcetagsandcodes.com"
  s.homepage = "http://github.com/matsadler/rack-idle"
end
