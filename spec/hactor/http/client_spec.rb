require 'spec_helper'
require 'hactor/http/client'

describe Hactor::HTTP::Client do
  let(:response_class) { mock }
  let(:backend) { mock }
  let(:actor) { mock }
  let(:client) do
    Hactor::HTTP::Client.new response_class: response_class,
                             backend: backend
  end

  describe "#get" do
    context "a valid URL is supplied" do
      let(:url) { 'http://example.com/' }
      let(:response) { stub }
      let(:hactor_response) { stub }
      let(:headers) { stub }

      it "GETs from URL and passes Response object to the actor" do
        backend.should_receive(:get)
          .with(url, nil, headers)
          .and_return(response)
        response_class.should_receive(:new)
          .with(response, http_client: client)
          .and_return(hactor_response)
        actor.should_receive(:call)
          .with(hactor_response)

        client.get(url: url, actor: actor, headers: headers)
      end
    end

  end

  describe "#follow" do
    let(:link) { mock }
    let(:uri) { stub }
    let(:context_url) { mock }
    let(:resolved_uri) { stub }

    before :each do
      Delegator.class_eval { include RSpec::Mocks::Methods }
      client.stub!(:get).with(url: resolved_uri, actor: actor)
    end

    context "plain url (no expand_with in option)" do
      it "should use the context url to resolve link href" do
        link.should_receive(:href)
        .and_return(uri)
        context_url.should_receive(:merge)
        .with(uri)
        .and_return(resolved_uri)

        client.follow(link, context_url: context_url, actor: actor)
      end
    end

    context "URI template (expand_with in option)" do
      it "should apply the variables to the template and follow resulting URI" do
        variables = stub

        link.should_receive(:href).with(variables).and_return(uri)
        context_url.should_receive(:merge).with(uri).and_return(resolved_uri)

        client.follow(link, context_url: context_url, actor: actor, expand_with: variables)
      end
    end
  end
end
