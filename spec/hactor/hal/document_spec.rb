require 'spec_helper'
require 'hactor/hal/document'

describe Hactor::HAL::Document do
  let(:resource_class) { mock }
  let(:response) { mock }
  let(:sentinel) { stub }
  let(:body) { '{}' }

  let(:doc) do
    Hactor::HAL::Document.new body,
      response: response,
      resource_class: resource_class
  end

  describe "#root_resource" do
    it "returns new Resource object" do
      resource_class.should_receive(:new)
        .with(JSON.parse(body), { rel: 'self', document: doc })
        .and_return(sentinel)

      doc.root_resource.should == sentinel
    end
  end

  describe "#base_url" do
    it "returns the url via the response object" do
      response.should_receive(:env).and_return url: sentinel
      doc.base_url.should == sentinel
    end
  end
end
