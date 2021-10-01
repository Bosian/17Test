platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

workspace '17Test.xcworkspace'

source 'https://cdn.cocoapods.org/'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        
        target.build_configurations.each do |config|

            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
            end

            # Align the development target in pod targets
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end

def promiseKit
    pod 'PromiseKit'
end

target '17Test' do
    project '17Test.xcodeproj'

    promiseKit
#    pod 'Kingfisher'
end

target 'WebAPI' do
    project 'WebAPI/WebAPI.xcodeproj'
    promiseKit
    target 'WebAPITests'
end
