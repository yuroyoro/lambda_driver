# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'class' do
  describe './' do
    subject { String / :index }

    it { should be_a_kind_of UnboundMethod }
    it("(klass / method_name).bind(obj).call(x) should be obj.method_name(x)"){
      subject.bind("foobarbaz").call("bar") == "foobarbaz".index("bar")
    }
  end
end
