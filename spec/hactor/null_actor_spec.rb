require 'hactor/null_actor'

describe Hactor::NullActor do
  let(:response) { mock }
  describe "#call" do
    it "should raise an exception when called" do
      response.should_receive(:inspect)

      expect {
        subject.call(response)
      }.to raise_exception(RuntimeError)
    end
  end
end
