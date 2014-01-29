# -*- encoding : utf-8 -*-
require 'spec_helper'

shared_examples_for 'method_or_lambda' do |label|
  let(:method_name) { :+ }
  context 'given method name (is reciever object responds)' do
    subject { method }

    it { should be_a_kind_of Method }
    it("#{label}.call(args) should be obj.send(method_name, args)"){
      subject.call('bar').should == object.send(method_name, 'bar')
    }
  end

  context 'given method name (is not reciever object responds)' do
    subject { lambda_proc }
    before {
      def object.method_missing(method, *args)
        method == :foo ? args : super(method, *args)
      end
    }

    it { should be_a_kind_of Proc }
    it("#{label}.call(args) should be obj.send(method_name, args)"){
      lambda_proc.call('bar', 'baz').should == object.send(:foo, 'bar', 'baz')
    }
  end
end

describe LambdaDriver::Op do
  describe '#_' do
    let(:object) { "foobarbaz" }

    context 'given nil' do
      subject { object._ }

      it { subject.class.should be_a_kind_of LambdaDriver::Op::Proxy }
    end

    it_should_behave_like 'method_or_lambda', 'obj._(method_name)' do
      let(:method){ object._(:+) }
      let(:lambda_proc){ object._(:foo) }
    end
  end
end

describe LambdaDriver::Op::Proxy do
  let(:object) { "foobarbaz" }

  describe '#call' do
    it_should_behave_like 'method_or_lambda', 'obj._(method_name)' do
      let(:method){ object._.call(:+) }
      let(:lambda_proc){ object._.call(:foo) }
    end
  end

  describe '#method_missing' do
    it_should_behave_like 'method_or_lambda', 'obj._.method_name' do
      let(:method){ object._.index }
      let(:method_name) { :index }
      let(:lambda_proc){ object._.foo }
    end
  end
end
