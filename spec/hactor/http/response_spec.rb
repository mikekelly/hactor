require 'spec_helper'
require 'hactor/http/response'

describe Hactor::HTTP::Response do
  let(:codec) { mock }
  let(:body) { mock }
  let(:wrapped_response) { mock }
  let(:http_client) { mock }

  describe "#follow" do
    let(:rel) { stub }
    let(:link) { stub }
    let(:actor) { stub }
    let(:response) do
      Hactor::HTTP::Response.new(wrapped_response,
                                 http_client: http_client,
                                 codec: codec,
                                 body: body)
    end

    it "gets the uri for the link with supplied rel" do
      options = { actor: actor, http_client: http_client }

      body.should_receive(:link).with(rel, options).and_return(link)
      http_client.should_receive(:follow)
        .with(link, actor: actor)

      response.follow(rel, options)
    end
  end

  describe "#body" do
    let(:body) { mock }
    let(:response) do
      Hactor::HTTP::Response.new(wrapped_response,
                                 http_client: http_client,
                                 codec: codec)
    end

    it "passes itself into the codec" do
      sentinel = stub
      wrapped_response.should_receive(:body).and_return(body)
      codec.should_receive(:new).with(body).and_return(sentinel)
      response.body.should == sentinel
    end
  end
end
