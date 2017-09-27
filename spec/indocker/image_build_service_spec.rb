require 'spec_helper'

describe 'Indocker::ImageBuildService' do
  subject { ioc.image_build_service }

  context 'for image without dependencies' do
    before do
      Indocker.define_image('indocker_image') do
        before_build { 'test' }
        
        from 'hello-world'
        workdir '.'
      end

      subject.build('indocker_image')
    end

    it 'builds image without dependencies' do
      expect(
        ioc.docker_api.image_exists_by_repo?('indocker_image')
      ).to be true
    end

    it 'updates image_metadata with image_id' do
      expect(
        ioc.image_repository.find_by_repo('indocker_image').id
      ).to eq(ioc.docker_api.find_image_by_repo('indocker_image').id)
    end

    it 'deletes build_path after image building' do
      image_metadata = ioc.image_repository.find_by_repo('indocker_image')

      expect(
        File.exists?(image_metadata.build_dir)
      ).to be false
    end
  end

  context 'for image with dependencies' do
    context 'circular dependencies' do
      before do
        Indocker.define_image('indocker_circular_image') do
          before_build do
            docker_cp 'circular_container' do
              copy '.', '.'
            end
          end
          
          from 'hello-world'
          workdir '.'
        end

        Indocker.define_container 'circular_container', from_repo: 'indocker_circular_image'
      end

      it 'raises Indocker::Errors::CircularImageDependency' do
        expect{
          subject.build('indocker_circular_image')
        }.to raise_error(Indocker::Errors::CircularImageDependency)
      end
    end

    context 'for non circular dependencies' do
      before do
        Indocker.define_image('indocker_image') do          
          from 'hello-world'
          workdir '.'
        end

        Indocker.define_image('indocker_image_with_dependency') do
          before_build do
            docker_cp 'container'
          end
          
          from 'hello-world'
          workdir '.'
        end

        Indocker.define_container 'container', from_repo: 'indocker_image'
        
        subject.build('indocker_image_with_dependency')
      end

      it 'runs before_build block for image' do
        expect_any_instance_of(Indocker::CommandsRunner).to receive(:run_all).at_least(:once)
        subject.build('indocker_image_with_dependency')
      end

      it 'builds image with dependency' do
        expect(
          ioc.docker_api.image_exists_by_repo?('indocker_image_with_dependency')
        ).to be true
      end
  
      it 'updates image_metadata with image_id' do
        expect(
          ioc.image_repository.find_by_repo('indocker_image_with_dependency').id
        ).to eq(ioc.docker_api.find_image_by_repo('indocker_image_with_dependency').id)
      end
    end
  end

  context 'for not existing image' do
    it 'raises Indocker::Errors::ImageIsNotDefined' do
      expect{
        subject.build('indocker_image_without_dependencies')
      }.to raise_error(Indocker::Errors::ImageIsNotDefined)
    end
  end
end