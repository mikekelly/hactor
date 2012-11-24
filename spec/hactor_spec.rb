require 'spec_helper'
require 'hactor'

describe Hactor do
  describe ".start" do
    context "a valid url is supplied" do
      let(:url) { 'http://example.com/' }
      let(:actor) { mock }
      let(:http_client) { mock }
      it "GETs from the URL and passes a response object to an actor" do
        http_client.should_receive(:follow).with(url: url, actor: actor)
        Hactor.start(url: url, actor: actor, http_client: http_client)
      end
    end
  end
end
