#
# Be sure to run `pod lib lint CoordinatorIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoordinatorIOS'
  s.version          = '0.1.0'
  s.summary          = 'Coordinator for MV*-C pattern'

  s.description      = 'Coordinator pattern base classses'

  s.homepage         = 'https://github.com/techpro-studio/CoordinatorIOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alex' => 'alex@techpro.studio' }
  s.source           = { :git => 'https://github.com/techpro-studio/CoordinatorIOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'CoordinatorIOS/Classes/**/*'
  s.swift_version = '5.3'
  
  # s.resource_bundles = {
  #   'CoordinatorIOS' => ['CoordinatorIOS/Assets/*.png']
  # }

   s.frameworks = 'UIKit', 'SafariServices'
end
