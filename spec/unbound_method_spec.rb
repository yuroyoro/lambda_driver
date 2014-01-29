# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UnboundMethod do
  describe '#<' do
    let(:unbound_method){ String.instance_method(:index) }
    subject { unbound_method < "foobarbaz" }

    it { should be_a_kind_of Method }
    it('(unbound_method < obj).call(x) should be unbound_method.bind(obj).call(x)'){
      subject.call('bar').should == unbound_method.bind("foobarbaz").call("bar")
    }
  end
end
