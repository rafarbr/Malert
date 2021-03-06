#
# Be sure to run `pod lib lint Malert.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'Malert'
  s.version          = '3.1.4'
  s.summary          = 'A simple, easy and very customizable alert'
  s.description      = <<-DESC
    Malert came to facilitate make custom alert views, introducing as `UIAlertController`.
                       DESC

  s.homepage         = 'https://github.com/vitormesquita/Malert'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vitor Mesquita' => 'vitor.mesquita09@gmail.com' }
  s.source           = { :git => 'https://github.com/vitormesquita/Malert.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Malert/Classes/**/*'
  s.resource_bundles = {
    'Malert' => ['Malert/Assets/*.png']
  }
end
