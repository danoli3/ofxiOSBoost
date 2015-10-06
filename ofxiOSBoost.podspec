Pod::Spec.new do |s|
  s.name         = "ofxiOSBoost"
  s.version      = "1.59.0"
  s.summary      = "Boost C++ library"
  s.description  = <<-DESC
Boost is the library that can (and should) be used to ease c++ development.
                   DESC
  s.homepage     = "http://www.boost.org"
  s.license      = 'Boost'
  s.author       = { "Danoli3" => "danoli3@gmail.com" }
  s.source       = { :git => "https://github.com/danoli3/ofxiOSBoost.git", :tag => "#{s.version}" }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = false
  s.ios.source_files = "libs/boost/include/**/*.{h,hpp,ipp}"
  s.ios.header_mappings_dir = "libs/boost/include"
  s.ios.public_header_files = "libs/boost/include/**/*.{h,hpp,ipp}"

  s.ios.preserve_paths = "libs/boost/include/**/*.{h,hpp,ipp}", "libs/boost/ios/**/*.a"
  s.ios.vendored_libraries = "libs/boost/ios/**/*.a"

end
