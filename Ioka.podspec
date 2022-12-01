Pod::Spec.new do |s|

  s.name                  = "Ioka"
  s.version               = "1.0.8"
  s.summary               = "Example of creating own pod."
  s.homepage              = "https://github.com/iokadev/ioka-ios.git"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "karaevablay" => "karaevablay@gmail.com" }
  s.platform              = :ios, '12.0'
  s.source                = { :git => "https://github.com/iokadev/ioka-ios.git", :tag => s.version.to_s }
  s.source_files = "IokaSDK/Classes/**/*.{swift}"
  s.resource_bundles = {
    'IokaSDK' => ['IokaSDK/Resources/**/*.{xcassets,lproj}']
  }

  s.swift_version= '5.0'
  
end
