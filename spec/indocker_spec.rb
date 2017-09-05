require 'spec_helper'

describe Indocker do
  include ExampleApplicationHelper

  describe '::init' do
    before do 
      initilize_application 
      described_class.init(example_project_path)
    end
    after  { reset_application }

    context 'setting Indocker.config' do
      it 'not raise error when access' do
        expect(Indocker.config).to be_a Indocker::Config
      end

      it 'with valid params' do
        expect(Indocker.config.docker_registry).to eq('localhost:5000')
      end
    end

    it 'sets Indocker.config.root' do
      expect(Indocker.root).to eq('/Users/vocrsz/dev/indocker/tmp/example')
    end

    it 'loads all images' do
      expect(Indocker.images.size).to eq(4)
      expect(Indocker.images.first).to be_a(Indocker::Image)
    end

    it 'loads all images and containers' do
      expect(Indocker.containers.size).to eq(2)
      expect(Indocker.containers.first).to be_a(Indocker::Container)
    end
  end
end