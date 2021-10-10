#
# Be sure to run `pod lib lint ggsdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ggsdk'
  s.version          = '0.1.2'
  s.summary          = 'A short description of ggsdk.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lenbolan/ggsdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lenbolan' => 'lanb2008@163.com' }
  s.source           = { :git => 'https://github.com/lenbolan/ggsdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ggsdk/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ggsdk' => ['ggsdk/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.static_framework = true
  
  s.swift_version = '5'
  
  s.dependency 'Alamofire', '~> 4.9.1'
  s.dependency 'Alamofire-SwiftyJSON', '~> 3.0.0'
  s.dependency 'Kingfisher', '~> 4.10.1'

  s.dependency 'GDTMobSDK', '~> 4.12.90'
  s.dependency 'Ads-CN', '~> 3.7.0.8'

  s.dependency 'TZImagePickerController', '~> 3.6.4'
  s.dependency 'Toast-Swift', '~> 5.0.1'
  s.dependency 'SwiftHEXColors', '~> 1.4.1'
end
