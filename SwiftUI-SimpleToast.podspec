#
# Be sure to run `pod lib lint SimpleToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftUI-SimpleToast'
  s.version          = '0.6.2'
  s.summary          = 'SimpleToast is a simple, lightweight, flexible and easy to use library to show toasts / popup notifications in SwiftUI.'
  s.swift_version    = '5.2'
  s.description      = <<-DESC
  SimpleToast is a simple, lightweight, flexible and easy to use library to show toasts / popup notifications inside iOS or MacOS applications in SwiftUI. Because of the flexibility to show any content it is also possible to use the library for showing simple modals.

  You decide the content, the library takes care about the rest.
                       DESC

  s.homepage         = 'https://github.com/sanzaru/SimpleToast'
  s.screenshots      = 'https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-slide.gif', 'https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-fade.gif', 'https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-scale.gif', 'https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-skew.gif'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'sanzaru' => 'sanzaru@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/sanzaru/SimpleToast.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  
  s.source_files = 'Sources/**/*'
  s.frameworks = 'SwiftUI'
end
