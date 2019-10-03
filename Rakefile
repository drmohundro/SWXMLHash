def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

desc 'Clean, build and test SWXMLHash'
task :test do |_t|
  xcode_build_cmd = 'xcodebuild -workspace SWXMLHash.xcworkspace -scheme "SWXMLHash iOS" -destination "OS=13.0,name=iPhone 11" clean build test -sdk iphonesimulator'

  if system('which xcpretty')
    run "#{xcode_build_cmd} | xcpretty -c"
  else
    run xcode_build_cmd
  end
end
