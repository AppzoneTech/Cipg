#
# Be sure to run `pod lib lint Cipg.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Cipg'
  s.version          = '0.1.4'
  s.summary          = 'Cipg IOS library for Consolidate payment gateway'

  s.homepage         = 'https://github.com/AppzoneTech/Cipg'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AppzoneTech' => 'techusers.user05@gmail.com' }
  s.source           = { :git => 'https://github.com/AppzoneTech/Cipg.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'

  s.source_files = 'Cipg/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Cipg' => ['Cipg/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ProgressHUD'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'SwiftyJSON', '~> 4.0'
end
