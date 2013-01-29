require 'spec_helper'
require 'hactor/hal/link'

describe Hactor::HAL::Link do
  context "templated link" do
    let(:template_class) { mock('templ_class') }
    let(:template) { mock('template') }
    let(:href) { stub }

    let(:state) do
      {
        'href' => href,
        'templated' => true
      }
    end

    let(:link) do
      Hactor::HAL::Link.new(state,{
        rel: stub,
        context: stub,
        template_class: template_class
      })
    end

    describe "#href" do
      it "expands using the variables passed in" do
        sentinel, variables = stub, stub

        template_class.should_receive(:new).with(href).
          and_return(template)
        template.should_receive(:expand).with(variables).
          and_return(stub(to_s: sentinel))

        link.href(variables).should == sentinel
      end
    end
  end
end
