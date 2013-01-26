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
  let(:http_client) { mock }

  let(:rel) { stub }
  let(:link) { stub }
  let(:base_url) { stub }
  let(:document) { stub(http_client: http_client, base_url: base_url) }

  let(:resource) do
    Hactor::HAL::Resource.new json,
                              rel: rel,
                              context: document
                                            
  end

  before :each do
    resource.link_collection_class = link_collection_class
    resource.embedded_collection_class = embedded_collection_class
  end

  context "http transition methods" do
    before :each do
      link_collection_class.should_receive(:new).and_return(link_collection)
      link_collection.should_receive(:find).with(rel).and_return(link)
    end

    describe "#follow" do
      it "tells the http client to follow the link and also supplies the context URL" do
        http_client.should_receive(:follow).with(link, { context_url: base_url })

        resource.follow(rel)
      end
    end

    describe "#traverse" do
      it "tells the http client to traverse the link using the supplied method and also supplies the context URL" do
        method = stub
        http_client.should_receive(:traverse).
          with(link, { method: method, context_url: base_url })

        resource.traverse(rel, method: method)
      end
    end
  end

  describe "#properties" do
    it "returns a Hash containing the json with the reserved properties removed" do
      resource.properties.should == { 'foo' => 'bar', 'baz' => 123 }
    end
  end

  context "links" do
    before :each do
      link_collection_class.should_receive(:new).
        with(json['_links'], parent: resource).and_return(link_collection)
    end

    describe "#link" do
      it "finds a link with the given rel" do
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
      embedded_collection_class.should_receive(:new).
        with(json['_embedded'], parent: resource).and_return(embedded_collection)
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
