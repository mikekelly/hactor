require 'spec_helper'
require 'hactor/hal/link_collection'

describe Hactor::HAL::LinkCollection do
  let(:simple_link_hash) do
    {
      'self' => { 'href' => '/' }
    }
  end
  let(:link_class) { mock }
  let(:flat_collection_class) { mock }
  let(:flat_collection) { mock }
  let(:link) { stub }
  let(:collection) do
    Hactor::HAL::LinkCollection.new(simple_link_hash,
                                    link_class: link_class,
                                    flat_collection_class: flat_collection_class)
  end

  describe "#find" do
    it "finds a link with the supplied rel" do
      flat_collection_class.should_receive(:new)
        .with(simple_link_hash, item_class: link_class)
        .and_return(flat_collection)
      flat_collection.should_receive(:find).and_return(link)

      collection.find_by_rel(:self).should == link
    end
  end
end
