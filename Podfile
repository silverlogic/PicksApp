platform :ios, '9.0'
inhibit_all_warnings!

target 'BaseAppV2' do
    use_frameworks!
    
    # Pods for BaseAppV2
    
    target 'BaseAppV2Tests' do
        inherit! :search_paths
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
    
    target 'BaseAppV2UITests' do
        inherit! :search_paths
        pod 'KIF-Kiwi'
    end
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
