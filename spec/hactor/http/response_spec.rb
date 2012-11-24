require 'spec_helper'
require 'hactor/http/response'

describe Hactor::HTTP::Response do
  let(:http_client) { mock }
  let(:codec) { mock }
  let(:body) { mock }
  let(:wrapped_response) { mock }
  let(:response) {
    Hactor::HTTP::Response.new(wrapped_response,
                               http_client: http_client,
                               codec: codec,
                               body: body
                              )}

  describe "#follow" do
    let(:rel) { stub }
    let(:uri) { stub }
    let(:actor) { stub }

    it "gets the uri for the link " do
      options = { actor: actor }

      body.should_receive(:link_uri).with(rel, options).and_return(uri)
      http_client.should_receive(:get)
        .with({ url: uri, actor: actor })

      response.follow(rel, options)
    end
  end

  describe "#body" do
    let(:body) { nil }

    it "passes itself into the codec" do
      sentinel = stub
      codec.should_receive(:new).with(response).and_return(sentinel)
      response.body.should == sentinel
    end
  end
end
