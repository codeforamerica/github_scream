require 'pp'
require 'yaml'
$sounds=YAML::load_file("cfa_coder_sounds/list.yml")

post "/receive_commit" do
	push = JSON.parse(params[:payload])
	puts "got push: "
	pp push

	#for now, assume all commits are by the same coder.
	author = push["commits"][0]["author"]
	repo = push["repository"]

	if repo["name"]=="cfa_coder_sounds"
		system("git submodule foreach git pull origin master")
		$sounds=YAML::load_file("cfa_coder_sounds/list.yml")
	end

	
	sound = $sounds["users"].values_at(*author.values).find {|x| !x.nil?} || ($sounds["projects"][repo["owner"]["name"]] || {})[repo["name"]] || $sounds["default"]
	system("mpg321 cfa_coder_sounds/sounds/#{sound}")
	
	push["commits"].each do |commit|
		next if commit["message"].match /^Merge branch/		
		message = commit["author"]["name"]+" pushed to "+repo["name"]+", "+commit["message"]
		message.gsub!(/["']/,'')
		puts "playing '#{message}'"
		system("echo '#{message}' | festival --tts")
		#sleep 5
	end
	
	[200,{},"coo"]
end
