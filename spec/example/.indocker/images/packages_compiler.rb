Indocker.image :packages_compiler do
  from 'ruby:alipine'

  workdir '/app'
  run 'touch package_file.rb'
end