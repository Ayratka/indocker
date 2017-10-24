Indocker.image :nginx do
  from 'nginx'

  before_build do |build_dir|
    container = run_container(:assets_compiler)
    container.extract from: 'assets', to: 'assets'
  end
end