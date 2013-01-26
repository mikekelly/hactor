require 'hactor/null_actor'

describe Hactor::NullActor do
  let(:response) { mock }
  describe "#call" do
    it "should raise an exception when called" do
      expect {
        subject.call(response)
      }.to raise_exception(RuntimeError)
    end
  end
end
