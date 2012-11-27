require 'spec_helper'
require 'hactor/http/client'

describe Hactor::HTTP::Client do
  let(:response_class) { mock }
  let(:backend) { mock }
  let(:client) { Hactor::HTTP::Client.new(response_class: response_class, backend: backend) }
  describe "#get" do
    context "a valid URL is supplied" do
      let(:url) { 'http://example.com/' }
      let(:actor) { mock }
      let(:response) { stub }
      let(:hactor_response) { stub }

      it "GETs from URL and passes Response object to the actor" do
        backend.should_receive(:get)
          .with(url)
          .and_return(response)
        backend.should_receive(:url_prefix=)
        backend.should_receive(:build_url).with(url)
        response_class.should_receive(:new)
          .with(response, http_client: client)
          .and_return(hactor_response)
        actor.should_receive(:call)
          .with(hactor_response)

        client.get(url: url, actor: actor)
      end
    end
  end
end
