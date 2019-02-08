Pod::Spec.new do |s|
  s.name             = 'DLAutoSlidePageViewController'
  s.version          = '0.4.0'
  s.summary          = 'An auto slide PageViewController.'
 
  s.description      = <<-DESC
An auto slide PageViewController with a customizable time interval. 
                       DESC
 
  s.homepage         = 'https://github.com/DeluxeAlonso/DLAutoSlidePageViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alonso Alvarez' => 'alonso.alvarez.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/DeluxeAlonso/DLAutoSlidePageViewController.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Source/DLAutoSlidePageViewController.swift'
 
end