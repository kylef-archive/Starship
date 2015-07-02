platform :ios, '8.0'
use_frameworks!

target 'Starship' do
  pod 'Representor'
  pod 'Hyperdrive'
  pod 'SVProgressHUD'
  pod 'VTAcknowledgementsViewController'
end

target 'StarshipTests' do

end

post_install do |installer|
  # Inject the plist acknowledements file into the resource
  # To be moved to CP plugin: https://github.com/CocoaPods/CocoaPods/issues/2465
  resources = File.read('Pods/Target Support Files/Pods-Starship/Pods-Starship-resources.sh').split("\n")
  rsync_index = resources.index { |line| line =~ /^rsync/ }
  resources.insert(rsync_index, 'install_resource "Target Support Files/Pods-Starship/Pods-Starship-acknowledgements.plist"')
  File.write('Pods/Target Support Files/Pods-Starship/Pods-Starship-resources.sh', resources.join("\n"))
end

class ::Pod::Generator::Acknowledgements
  def specs
    file_accessors.map { |accessor| accessor.spec.root }.uniq.reject do |spec|
      spec.name == 'VTAcknowledgementsViewController'
    end
  end
end

