require 'spec_helper'
require 'hactor/http/response'

describe Hactor::HTTP::Response do
  let(:codec) { mock }
  let(:http_client) { mock }
  let(:response) { Hactor::HTTP::Response.new(stub, codec: codec, http_client: http_client) }

  describe "#follow" do

  end

  describe "#body" do
    it "passes itself into the codec" do
      sentinel = stub
      codec.should_receive(:new).with(response).and_return(sentinel)
      response.body.should == sentinel
    end
  end
end
