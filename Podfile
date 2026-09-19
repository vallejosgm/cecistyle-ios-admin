platform :ios, '13.0'

target 'CeciStyleAdmin' do
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Messaging'

  # 👇 Fuerza el mínimo de despliegue a todos los targets generados por pods
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
