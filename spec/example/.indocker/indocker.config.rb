require 'indocker'

Indocker.setup do
  docker_registry 'localhost:5000'      

  docker_images ['images/**/*.rb', 'containers/**/*.rb']
  env_files     ['env_files/**/*.env']
end