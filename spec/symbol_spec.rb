# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Symbol do
  describe '#compose' do
    subject { :to_s }

    it_should_behave_like 'composable'
  end

  describe '#with_args' do
    subject {:delete }

    it_should_behave_like 'with_args' do
      let(:x) { 'foobar' }
      let(:y) { 'o'  }
      let(:z) { 'a'}
    end
  end

  describe '#flip' do
    context 'arity = 1' do
      subject { :to_s }

      it_should_behave_like 'flip(arity=1)'
    end

    context 'varargs' do
      subject {:product }

      it_should_behave_like 'flip(varargs)' do
        let(:x) { [:bar] }
        let(:y) { [:foo] }
      end
    end
  end

  describe '#curry' do
    subject { :product }

    it_should_behave_like 'curry(varargs)' do
      let(:x) { [:bar] }
      let(:y) { [:foo] }
    end
  end

  describe '#call' do
    subject { :to_s }

    it_should_behave_like 'call(<)'
  end

  describe 'ailases' do
    subject { :to_s }

    it_should_behave_like 'aliases'

    it_should_behave_like 'aliases(varargs)' do
      subject { :delete}
      let(:x) { :bar }
      let(:y) { 'a' }
    end
  end

  describe '#to_method' do
    subject { :index.to_method }

    let(:obj) { "foobarbaz" }

    it { should be_a_kind_of Proc }
    it('symbol.to_method.call(obj) should returns Method'){
      subject.call(obj).should be_a_kind_of Method
    }

    it('symbol.to_method.call(obj).call(x) should be obj.method(symbol).call(x)'){
      subject.call(obj).call("bar").should == obj.method(:index).call("bar")
    }

    it('(-:symbol).call(obj) should returns Method'){
      (-:index).call(obj).should be_a_kind_of Method
    }

    it('(-:symbol).call(obj).call(x) should be obj.method(symbol).call(x)'){
      (-:index).call(obj).call("bar").should == obj.method(:index).call("bar")
    }

    it('-:symbol < obj < x should be obj.method(symbol).call(x)'){
      (-:index < obj <"bar").should == obj.method(:index).call("bar")
    }
  end

  describe '#to_method_with_args' do
    subject { :index.to_method_with_args("bar") }

    let(:obj) { "foobarbaz" }

    it { should be_a_kind_of Proc }

    it('symbol.to_method_with_args(x).call(obj) should be obj.method(symbol).call(x)'){
      subject.call(obj).should == obj.method(:index).call("bar")
    }

    it('(:symbol & x).call(obj) should be obj.method(symbol).call(x)'){
      (:index & 'bar').call(obj).should == obj.method(:index).call("bar")
    }

    it('(:symbol & x <obj) should be obj.method(symbol).call(x)'){
      (:index & 'bar' < obj).should == obj.method(:index).call("bar")
    }
  end
end
