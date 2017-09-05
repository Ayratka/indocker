require 'spec_helper'

describe 'Indocker::ConfigLocator' do
  include ExampleApplicationHelper

  subject { ioc.config_locator }

  before { initilize_application }
  after  { reset_application }

  describe '#locate' do
    it 'works within valid root folder' do
      expect(
        subject.locate(example_project_path)
      ).to eq(example_project_path)
    end

    it "works in any (deep) subfolder of valid root folder" do
      expect(
        subject.locate(File.join(example_project_path, 'package_compiler'))
      ).to eq(example_project_path)
    end

    it "even works for non-exiting subfolders of valid root folder" do
      expect(
        subject.locate(File.join(example_project_path, 'invalid/folder'))
      ).to eq(example_project_path)
    end

    it "raises when config file could not be found in any folder for the whole folder hierarchy" do
      path = "/tmp/not/valid"
      expect {
        subject.locate(path)
      }.to raise_error(Indocker::Errors::ConfigFileDoesNotExist)
    end
  end
end