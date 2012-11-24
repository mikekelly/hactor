require 'spec_helper'
require 'hactor/http/response'

describe Hactor::HTTP::Response do
  let(:codec) { mock }
  let(:body) { mock }
  let(:wrapped_response) { mock }
  let(:response) {
    Hactor::HTTP::Response.new(wrapped_response,
                               codec: codec,
                               body: body
                              )}

  describe "#follow" do
    let(:http_client) { mock }
    let(:rel) { stub }
    let(:link) { stub }
    let(:actor) { stub }

    it "gets the uri for the link with supplied rel" do
      options = { actor: actor, http_client: http_client }

      body.should_receive(:link).with(rel, options).and_return(link)
      http_client.should_receive(:follow)
        .with(link, actor: actor)

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
