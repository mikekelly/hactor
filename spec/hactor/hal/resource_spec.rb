require 'spec_helper'
require 'hactor/hal/resource'

describe Hactor::HAL::Resource do
  let(:json) do
    {
      '_links' => {
        'self' => { 'href' => '/' }
      },
      '_embedded' => {
        'widget' => { 'bla' => 'x' }
      },
      'foo' => 'bar',
      'baz' => 123
    }
  end

  let(:link_collection_class) { mock }
  let(:link_collection) { mock }
  let(:embedded_collection_class) { mock }
  let(:embedded_collection) { mock }
  let(:rel) { stub }

  let(:resource) do
    Hactor::HAL::Resource.new json,
                              rel: rel
  end

  before :each do
    resource.link_collection_class = link_collection_class
    resource.embedded_collection_class = embedded_collection_class
  end

  describe "#properties" do
    it "returns a Hash containing the json with the reserved properties removed" do
      resource.properties.should == { 'foo' => 'bar', 'baz' => 123 }
    end
  end

  context "links" do
    before :each do
      link_collection_class.should_receive(:new).with(json['_links']).and_return(link_collection)
    end

    describe "#link" do
      it "finds a link with the given rel" do
        link = stub
        link_collection.should_receive(:find).with(rel).and_return(link)
        resource.link(rel).should == link
      end
    end

    describe "#links" do
      it "returns a new link set" do
        resource.links.should == link_collection
      end
    end
  end

  context "embedded resources" do
    before :each do
      embedded_collection_class.should_receive(:new).with(json['_embedded']).and_return(embedded_collection)
    end

    describe "#embedded_resource" do
      it "finds an embedded resource with the given rel" do
        embedded_resource = stub
        embedded_collection.should_receive(:find).with(rel).and_return(embedded_resource)
        resource.embedded_resource(rel).should == embedded_resource
      end
    end

    describe "#embedded_resources" do
      it "returns a new embedded set" do
        resource.embedded_resources.should == embedded_collection
      end
    end
  end
end
