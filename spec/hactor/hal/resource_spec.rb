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
  let(:resource) { Hactor::HAL::Resource.new(json) }
  let(:sentinel) { stub }

  describe "#properties" do
    it "returns a Hash containing the json with the reserved properties removed" do
      resource.properties.should == { 'foo' => 'bar', 'baz' => 123 }
    end
  end

  describe "#link" do

  end

  describe "#link_uri" do

  end

  describe "#links" do
    let(:link_set_class) { mock }
    it "returns a new link set" do
      link_set_class.should_receive(:new).with(json['_links']).and_return(sentinel)
      resource.links(link_set_class: link_set_class).should == sentinel
    end
  end

  describe "#embedded_resource" do

  end

  describe "#embedded_resources" do
    let(:embedded_set_class) { mock }
    it "returns a new embedded set" do
      embedded_set_class.should_receive(:new).with(json['_embedded']).and_return(sentinel)
      resource.embedded_resources(embedded_set_class: embedded_set_class).should == sentinel
    end
  end
end
