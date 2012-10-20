APP_NAME = 'shotify'
APP_ON_DROPBOX = "~/Dropbox/shared/vampirehackathon/#{APP_NAME}"

desc "Build the website from source"
task :build do
  puts "## Building website"
  status = system("middleman build --clean")
  puts status ? "OK" : "FAILED"
end

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("middleman server")
end

desc "Deploy to spotify"
task :deploy do
  puts "## Copying to spotify"
  status = system("mkdir -p ~/Spotify && mkdir -p ~/Spotify/#{APP_NAME} && cp -Rf build/* ~/Spotify/#{APP_NAME}")
  puts status ? "OK" : "FAILED"
end

desc "Shot: Build and deploy website"
task :shot => [:build, :deploy] do
end

desc "Deploy to dropbox"
task :dropbox do
  puts "## Copying to Dropbox at #{APP_ON_DROPBOX}"
  status = system("mkdir -p #{APP_ON_DROPBOX} && cp -Rf build/* #{APP_ON_DROPBOX}")
  puts status ? "OK" : "FAILED"
end
