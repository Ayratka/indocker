require 'spec_helper'

describe Indocker::Container do
  let(:tmp_dir) { File.expand_path('../../tmp', __dir__) }
  let(:image_name) { 'example_image' }

  subject { 
    described_class.new :example_container do 
      from_image 'example_image'
    end
  }

  after do
    ioc.shell_commands.run_command("docker image rm $(docker images #{image_name} -q) --force")
  end

  context 'for image without dependencies' do
    it "runs" do
      Indocker.image image_name do
        from 'hello-world'
      end

      subject.run
    end
  end

end