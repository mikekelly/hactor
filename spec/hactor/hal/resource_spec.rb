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

  let(:resource) do
    Hactor::HAL::Resource.new(json,
                              link_set_class: link_set_class,
                              embedded_set_class: embedded_set_class)
  end

  let(:link_set_class) { mock }
  let(:embedded_set_class) { mock }
  let(:link_set) { mock }
  let(:embedded_set) { mock }
  let(:rel) { stub }

  describe "#properties" do
    it "returns a Hash containing the json with the reserved properties removed" do
      resource.properties.should == { 'foo' => 'bar', 'baz' => 123 }
    end
  end

  context "links" do
    before :each do
      link_set_class.should_receive(:new).with(json['_links']).and_return(link_set)
    end

    describe "#link" do
      it "finds a link with the given rel" do
        link = stub
        link_set.should_receive(:find).with(rel).and_return(link)
        resource.link(rel).should == link
      end
    end

    describe "#links" do
      it "returns a new link set" do
        resource.links.should == link_set
      end
    end
  end

  context "embedded resources" do
    before :each do
      embedded_set_class.should_receive(:new).with(json['_embedded']).and_return(embedded_set)
    end

    describe "#embedded_resource" do
      it "finds an embedded resource with the given rel" do
        embedded_resource = stub
        embedded_set.should_receive(:find).with(rel).and_return(embedded_resource)
        resource.embedded_resource(rel).should == embedded_resource
      end
    end

    describe "#embedded_resources" do
      it "returns a new embedded set" do
        resource.embedded_resources.should == embedded_set
      end
    end
  end
end
