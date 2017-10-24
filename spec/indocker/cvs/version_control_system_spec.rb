require 'spec_helper'

describe  'VersionControlSystem' do 
  
  context 'branch' do
    let(:version_control_system) do
      @version_control_system =  VersionControlSystem.new( 
        repository_name = "https://github.com/schacon/ruby-git",
        branch_name     =  "test",
        @tag_name       =  nil,
        @work_dir =  "workdir")
    end

    it 'uses to pull from branch' do
      expect(@version_control_system.use).to be_instance_of(PullBranch)
    end

    it 'exists directory' do
      directory = File.expand_path(File.join("workdir", "branches", "test"))
      expect(Dir.exist?(directory)).to be(true)
    end

  end

  context 'tag' do
    let(:version_control_system) do
      @version_control_system =  VersionControlSystem.new( 
        repository_name = "https://github.com/schacon/ruby-git",
        branch_name     =  nil,
        @tag_name       =  "v1.2.3",
        @work_dir =  "workdir")
    end

    it 'uses to pull from tag' do
      expect(@version_control_system.use).to be_instance_of(PullTag)
    end

    it 'exists directory' do
      directory = File.expand_path(File.join("workdir", "tags", "v1.2.3"))
      expect(Dir.exist?(directory)).to be(true)
    end

  end

end