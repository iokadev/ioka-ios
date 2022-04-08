Pod::Spec.new do |s|
  s.name                  = "ioka"
  s.version               = "0.0.1"
  s.summary               = "Example of creating own pod."
  s.homepage              = "https://github.com/iokadev/ioka-ios.git"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "karaevablay" => "karaevablay@gmail.com" }
  s.platform              = :ios, '12.0'
  s.source                = { :git => "https://github.com/iokadev/ioka-ios.git", :tag => s.version.to_s }
  s.source_files = ‘ioka/Classes/*.swift’
end
