What's this all about?
	In "It's a Wonderful Life", Every time an angel gets his wings, a little bell rings.
	With this code running, every time a developer pushes to your github repo, a bloodcurdling hawk scream will erupt from your office's speakers!

Cool. How do I set it up?
	You need a couple things. First, the environment:
	
	* First, set up a linux-based server to run it on, and attach to it some speakers. The louder, the better.
	* This server will need a publicly accessible IP address & port.
	* This server will need the 'festival' text-to-speech program installed.
		Festival's web site is here: http://www.cstr.ed.ac.uk/projects/festival/download.html
		Follow your distribution's recommended setup for festival.
		[This is somewhat involved, and deserves a more fleshed-out readme]
	* You'll need git set up on this server.
		git clone <this_repo>
	* This computer will need ruby. The code has only been tested with ruby 1.9.2, so that's recommended. However, 1.8.7 should probably work with little to no modification.
	* You'll need to install the necessary gems. This project uses bundler to manage gem dependencies
		gem install bundler
		bundle install
	
	Next, the sounds:
		* Set up a 'sounds' repository on github for your organization. name it anything you like
		* for examples, see examples/sound_repo, or check out our sounds here: https://github.com/codeforamerica/cfa_coder_sounds
		* make sure there's a process in place for letting people upload new sounds into your repo!
		* the HAWK SCREAM has been included in examples/example_sound_repo/sounds/hawk.mp3 to get you started. :)
	
	Then, configuration:
	
	* in the root of the project directory, you'll need a config.yml file
		this is a YAML based configuration file. it needs to have the key "sound_repo", referring to the name of your sound repository
	* in the root of the project directory, 'git clone' your sounds repo, so it appears as a subdirectory
	* THIS IS THE IMPORTANT PART: on any github repository you want to have scream, go to 'admin'->'service hooks' -> 'Post-Receive URLs', and add a line of this form:
		<your server's address><:port>/receive_commit
	
	Finally, launching it:
	* On your server, in the project directory, issue
		rackup -p <port>
	* to test it, go to your github repository, 'admin'->'service hooks' -> 'Post-Receive URLs', and click 'test hook'
	* pump up the volume

Contributing
	Got a great idea for a feature, or a horrible bug?
	Please report issues, bugs, or feature requests with github's 'Issues' button (https://github.com/codeforamerica/github_scream/issues)
	If you want to contribute code:
		Fork the repository
		make any changes you want, and commit them to your repository
			please make sure your commits are as granular as possible!
		issue a 'pull request', and I'll pull your changes into the main repository.
