require 'spec_helper'
require 'hactor/http/response'

describe Hactor::HTTP::Response do
  let(:codec) { mock 'codec' }
  let(:body) { mock 'body' }
  let(:wrapped_response) { mock 'wrapped_response' }
  let(:http_client) { stub }

  describe "#follow" do
    let(:rel) { stub }
    let(:response) do
      Hactor::HTTP::Response.new(wrapped_response,
                                 http_client: http_client,
                                 codec: codec,
                                 body: body)
    end

    it "delegates to the body" do
      options = stub

      body.should_receive(:follow).with(rel, options)

      response.follow(rel, options)
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
      codec.should_receive(:new).
        with(body, response: response).
        and_return(sentinel)

      response.body.should == sentinel
    end
  end
end
