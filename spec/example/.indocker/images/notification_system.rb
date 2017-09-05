Indocker.image :notifications_sytem do
  from 'ruby:2.3.1'

  before_build do |build_dir|
    container = run_container(:packages_compiler)
    container.extract from: 'notification_system', to: build_dir
  end

  copy from: '.', to: '.'

  cmd './bin/run'
end