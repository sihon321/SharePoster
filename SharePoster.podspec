#
# Be sure to run `pod lib lint SharePoster.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SharePoster'
  s.version          = '0.6.0'
  s.summary          = 'SharePoster is to help users post content(image, video, url, etc..) in Share Extension'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Posting Content in developer.apple.com is example using SLComposeServiceViewController. This library can be used when using a custom ViewController.
                       DESC

  s.homepage         = 'https://github.com/sihon321/SharePoster'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sihon321' => 'sihon321@gmail.com' }
  s.source           = { :git => 'https://github.com/sihon321/SharePoster.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.2'
  s.ios.deployment_target = '8.0'

  s.source_files = 'SharePoster/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SharePoster' => ['SharePoster/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
