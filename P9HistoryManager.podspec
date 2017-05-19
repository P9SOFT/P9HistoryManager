Pod::Spec.new do |s|

  s.name         = "P9HistoryManager"
  s.version      = "1.0.1"
  s.summary      = "Photo Album handling module based on Hydra framework."
  s.homepage     = "https://github.com/P9SOFT/P9HistoryManager"
  s.license      = { :type => 'MIT' }
  s.author       = { "Tae Hyun Na" => "taehyun.na@gmail.com" }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source       = { :git => "https://github.com/P9SOFT/P9HistoryManager.git", :tag => "1.0.1" }
  s.source_files  = "Sources/*.{h,m}"
  s.public_header_files = "Sources/*.h"

end
