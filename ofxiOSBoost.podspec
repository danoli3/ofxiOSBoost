Pod::Spec.new do |s|
  s.name         = "ofxiOSBoost"
  s.version      = "1.57"
  s.summary      = "Boost c++ library"
  s.description  = <<-DESC
Boost is the library that can (and should) be used to ease c++ development.
                   DESC
  s.homepage     = "http://www.boost.org"
  s.license      = 'Boost'
  s.author       = { "Gena" => "g.evstratov@gmail.com" }
  s.source       = { :git => "https://github.com/egv/ofxiOSBoost.git", :tag => "#{s.version}" }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = false
  s.ios.source_files = "libs/boost/include/**/*.hpp"
  s.ios.header_mappings_dir = "libs/boost/include"
  s.ios.public_header_files = "libs/boost/include/**/*.hpp"

  s.ios.preserve_paths = "libs/boost/include/**/*.hpp", 
                         "libs/boost/ios/**/*.a"
  s.ios.vendored_libraries = "libs/boost/ios/**/*.a"

end
