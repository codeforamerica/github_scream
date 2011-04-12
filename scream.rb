$sounds={}
$default_sound="/home/moto/hawk.mp3"
require 'pp'
post "/receive_commit" do
	push = JSON.parse(params[:payload])
	puts "got push: "
	pp push
		#for now, just do the first. leaving the block syntax in here for future use
	system("mpg321 -g60 #{$default_sound}")

	push["commits"].each do |commit|
		next if commit["message"].match /^Merge branch/
		message = commit["author"]["name"]+" pushed to "+push["repository"]["name"]+", "+commit["message"]
		message.gsub!(/"'/,'')
		puts "playing '#{message}'"
		system("echo '#{message}' | festival --tts")
		#sleep 5
	end

	[200,{},"coo"]
end
