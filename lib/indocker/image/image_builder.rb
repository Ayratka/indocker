class Indocker::ImageBuilder
  include SmartIoC::Iocify

  bean   :image_builder
  
  inject :image_metadata_repository
  inject :image_dependencies_manager
  inject :directives_runner
  inject :image_evaluator
  inject :docker_api

  def build(repo, tag: Indocker::ImageMetadata::DEFAULT_TAG)
    image_metadata = image_metadata_repository.find_by_repo(repo, tag: tag)
    
    FileUtils.mkdir_p(image_metadata.build_dir)
    
    image_dependencies_manager.get_dependencies!(image_metadata)

    directives_runner.run_all(image_metadata.prepare_directives)

    File.open(File.join(image_metadata.build_dir, Indocker::DOCKERFILE_NAME), 'w') do |f| 
      f.puts image_metadata.build_directives.map(&:to_s)
    end

    docker_api.build_from_dir(image_metadata)
    image_metadata.image_id = docker_api.find_image_by_repo(image_metadata.repo, tag: image_metadata.tag).id

    FileUtils.rm_rf(image_metadata.build_dir)
  end
end