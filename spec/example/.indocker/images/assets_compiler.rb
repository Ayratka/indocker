Indocker.image :assets_compiler do
  from 'ruby:alipine'

  workdir '/app'
  run 'touch assets/example_file.rb'
end