require 'spec_helper'
require 'hactor/http/client'

describe Hactor::HTTP::Client do
  let(:response_class) { mock }
  let(:backend) { mock }
  let(:actor) { mock }
  let(:link) { mock }
  let(:context_url) { mock }

  let(:variables) { stub }
  let(:uri) { stub }
  let(:resolved_uri) { stub }
  let(:response) { stub }
  let(:headers) { stub }
  let(:hactor_response) { stub }
  let(:url) { 'http://example.com/' }

  let(:client) do
    Hactor::HTTP::Client.new response_class: response_class,
                             backend: backend
  end

  describe "#follow" do
    before :each do
      context_url.should_receive(:merge).with(uri).
        and_return(resolved_uri)

      response_class.should_receive(:new).with(response, http_client: backend).
        and_return(hactor_response)

      actor.should_receive(:call).with(hactor_response)
    end

    context "plain url (no expand_with in option)" do
      it "should use the context url to resolve link href" do
        link.should_receive(:href).with(nil)
          .and_return(uri)
        backend.should_receive(:get).with(resolved_uri, nil, headers).
          and_return(response)

        client.follow link,
                      context_url: context_url,
                      actor: actor,
                      headers: headers
      end
    end

    context "URI template (expand_with in option)" do
      it "should apply the variables to the template and follow resulting URI" do
        link.should_receive(:href).with(variables).and_return(uri)
        backend.should_receive(:get).with(resolved_uri, nil, headers).
          and_return(response)

        client.follow link,
                      context_url: context_url,
                      actor: actor,
                      expand_with: variables,
                      headers: headers
      end
    end
  end

  describe "#traverse" do
    let(:method) { 'POST' }
    let(:body) { stub 'body' }

    it "should send a message of the given method to the http backend" do
      link.should_receive(:href).with(variables).and_return(uri)
      context_url.should_receive(:merge).with(uri).
        and_return(resolved_uri)
      backend.should_receive('post').with(resolved_uri, body, headers).
        and_return(response)
      response_class.should_receive(:new).with(response, http_client: backend).
        and_return(hactor_response)
      actor.should_receive(:call).with(hactor_response)

      client.traverse link,
                      context_url: context_url,
                      method: method,
                      headers: headers,
                      body: body,
                      actor: actor,
                      expand_with: variables
    end
  end
end
