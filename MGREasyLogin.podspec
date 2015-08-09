Pod::Spec.new do |s|
  s.name                  = "MGREasyLogin"
  s.version               = "0.0.1"
  s.summary               = "The manager for easy login in Facebook and Twitter"
  s.homepage              = "https://github.com/imerkulov/MGREasyLogin"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Username" => "ilya.imlove@gmail.com" }
  s.platform              = :ios, '7.0'
  s.source                = { :git => "https://github.com/imerkulov/MGREasyLogin.git", :tag => s.version.to_s }
  s.source_files          = 'Classes/*.{h,m}'
  s.public_header_files   = 'Classes/*.h'
  s.framework             = 'Foundation, Social, Accounts'
  s.requires_arc          = true
end