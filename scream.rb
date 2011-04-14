require 'pp'
require 'yaml'

$config = YAML::load_file("config.yml")
$sound_repo = $config["sound_repo"]
Dir.chdir($sound_repo) #treat our sounds repo as our current working directory, so we can directly access the config list and the sounds, without prefixing.
$sounds = YAML::load_file("list.yml")


post "/receive_commit" do
	push = JSON.parse(params[:payload])
	puts "got push: "
	pp push

	repo = push["repository"]

	if repo["name"] == $sound_repo
		system("git pull origin master")
		$sounds = YAML::load_file("list.yml")
	end
	
	#group commits by the announcing sound
	commits_by_sound = push["commits"].group_by do |commit|
		sound = $sounds["users"].values_at(*commit["author"].values).find {|x| !x.nil?}	#announcing sound is the configured user-specific sound
		sound ||= ($sounds["projects"][repo["owner"]["name"]] || {})[repo["name"]]		#if that didn't work, try the project-specific sound
		sound ||= $sounds["default"]													#otherwise, the default sound
		sound
	end
	
	commits_by_sound.each do |sound,commits|
		system("mpg321 sounds/#{sound}")
		commits.each do |commit|
			next if commit["message"].match /^Merge branch/
			
			message = commit["author"]["name"]+" pushed to "+repo["name"]+", "+commit["message"]
			message.gsub!(/["']/,'')
			message.gsub! '#',' hash '
			puts "playing '#{message}'"
			system("echo '#{message}' | festival --tts")
		end
	end
	
	[200,{},"coo"]
end
