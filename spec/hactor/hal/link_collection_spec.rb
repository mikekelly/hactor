require 'spec_helper'
require 'hactor/hal/link_collection'

describe Hactor::HAL::LinkCollection do
  let(:links_hash) do
    {
      'self' => { 'href' => '/' }
    }
  end

  describe "#find" do
    it "finds a link with the supplied rel" do
      set = Hactor::HAL::LinkCollection.new(links_hash)
    end
  end
end
