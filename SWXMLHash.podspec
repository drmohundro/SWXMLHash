Pod::Spec.new do |s|
  s.name        = 'SWXMLHash'
  s.version     = '7.0.2'
  s.summary     = 'Simple XML parsing in Swift'
  s.homepage    = 'https://github.com/drmohundro/SWXMLHash'
  s.license     = { type: 'MIT' }
  s.authors     = { 'David Mohundro' => 'david@mohundro.com' }

  s.requires_arc = true
  s.pod_target_xcconfig = {
    'APPLICATION_EXTENSION_API_ONLY' => 'YES'
  }

  s.swift_version = '5.0'
  s.osx.deployment_target = '10.13'
  s.ios.deployment_target = '11.0'
  s.watchos.deployment_target = '4.0'
  s.tvos.deployment_target = '11.0'

  s.source = {
    git: 'https://github.com/drmohundro/SWXMLHash.git',
    tag: s.version
  }
  s.source_files = 'Source/**/*.swift'
end
