def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

desc 'Clean, build and test SWXMLHash'
task :test do |_t|
  # xctool_build_cmd = './scripts/build.sh'
  xcode_build_cmd = 'xcodebuild -workspace SWXMLHash.xcworkspace -scheme "SWXMLHash iOS" -destination "OS=11.0.1,name=iPhone 7" clean build test -sdk iphonesimulator'

  #if system('which xctool')
    #run xctool_build_cmd
  #else
    if system('which xcpretty')
      run "#{xcode_build_cmd} | xcpretty -c"
    else
      run xcode_build_cmd
    end
  #end
end
