def run(command)
	system(command) or raise "RAKE TASK FAILED: #{command}"
end

desc "Clean, build and test SWXMLHash"
task :test do |t|
	cmd = "xcodebuild -project SWXMLHash.xcodeproj -scheme SWXMLHash clean build test"
	if system('which xcpretty')
		run "#{cmd} | xcpretty -c"
	else
		run cmd
	end
end
