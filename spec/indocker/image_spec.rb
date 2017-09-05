require 'spec_helper'

describe Indocker::Image do
  include ExampleApplicationHelper
  
  let(:image_name) { 'example_image' }
  subject { 
    described_class.new image_name do
      from 'hello-world'
    end
  }

  before { initilize_application }

  after do
    reset_application
    ioc.shell_commands.run_command("docker image rm $(docker images #{image_name} -q) --force")
  end

  describe "#build" do
    context "without dependencies" do
      it 'build image from object' do
        subject.build(File.join(example_project_path, 'tmp'))
      end
    end
  end
end