require 'pp'
require 'yaml'

$config = YAML::load_file("config.yml")
$sound_repo = $config["sound_repo"]
Dir.chdir($sound_repo) #treat our sounds repo as our current working directory, so we can directly access the config list and the sounds, without prefixing.

post "/receive_commit" do
	push = JSON.parse(params[:payload])
	puts "got push: "
	pp push

	repo = push["repository"]

	if repo["name"] == $sound_repo
		system("git pull origin master")
	end

    commits_by_sound = push["commits"].group_by do |commit|
        sound = commit["author"]["username"]+".mp3" if File.exist?("sounds/"+commit["author"]["username"]+".mp3") # check for user
        sound ||= repo["owner"]["name"]+"/"+repo["name"]+".mp3" if File.exist?("sounds/"+repo["owner"]["name"]+"/"+repo["name"]+".mp3") # check for project
        sound ||= "default.mp3" # default
    end

	commits_by_sound.each do |sound,commits|
        system("mpg321 sounds/#{sound}")
        message = commits[0]["author"]["name"]+" pushed #{commits.length} commit#{'s' unless commits.length==1} to "+repo["name"]
        message.gsub!(/["']/,'')
        message.gsub! '#',' hash '
        puts "playing '#{message}'"
        system("echo '#{message}' | festival --tts")
    end
	
	[200,{},"coo"]
end
