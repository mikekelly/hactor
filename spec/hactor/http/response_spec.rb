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
    let(:context_url) { stub }
    let(:response) do
      Hactor::HTTP::Response.new(wrapped_response,
                                 http_client: http_client,
                                 codec: codec,
                                 body: body)
    end

    it "follows the link with supplied rel" do
      body.should_receive(:link).with(rel).and_return(link)
      http_client.should_receive(:follow)
        .with(link, context_url: context_url, actor: actor)
      wrapped_response.should_receive(:env)
        .and_return({ url: context_url })

      response.follow(rel, actor: actor, http_client: http_client)
    end
  end

  describe "#body" do
    let(:body) { mock }
    let(:sentinel) { stub }
    let(:response) do
      Hactor::HTTP::Response.new(wrapped_response,
                                 http_client: http_client,
                                 codec: codec)
    end

    it "passes itself into the codec" do
      wrapped_response.should_receive(:body).and_return(body)
      codec.should_receive(:new).with(body).and_return(sentinel)

      response.body.should == sentinel
    end
  end
end
