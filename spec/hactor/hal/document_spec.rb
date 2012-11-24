require 'spec_helper'
require 'hactor/hal/document'

describe Hactor::HAL::Document do
  describe "#root_resource" do
    let(:resource_class) { mock }
    let(:sentinel) { stub }
    let(:body) { '{}' }
    it "returns new Resource object" do
      resource_class.should_receive(:new)
        .with(JSON.parse(body))
        .and_return(sentinel)
      doc = Hactor::HAL::Document.new(body, resource_class: resource_class)
      doc.root_resource.should == sentinel
    end
  end
end
