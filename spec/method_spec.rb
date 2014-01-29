# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Method do
  describe '#compose' do
    subject { "aaa".method(:+) }

    it_should_behave_like 'composable' do
      let(:x) { "foo" }
    end
  end

  describe '#with_args' do
    subject { "foobarbaz".method(:delete) }

    it_should_behave_like 'with_args' do
      let(:x) { 'r' }
      let(:y) { 'o' }
      let(:z) { 'a' }
    end
  end

  describe '#flip' do
    context 'arity = 1' do
      subject { "aaa".method(:+) }

      it_should_behave_like 'flip(arity=1)' do
        let(:x) { "foo" }
        let(:y) { "bar" }
      end
    end

    context 'arity > 1' do
      subject { "foobarbaz".method(:tr) }

      it_should_behave_like 'flip' do
        let(:x) { 'r' }
        let(:y) { 'o' }
      end
    end

    context 'varargs' do
      subject { "foobarbaz".method(:delete) }

      it_should_behave_like 'flip(varargs)' do
        let(:x) { 'r' }
        let(:y) { 'o' }
      end
    end
  end

  describe '#curry' do
    context 'arity > 1' do
      subject { "foobarbaz".method(:tr) }

      it_should_behave_like 'curry' do
        let(:x) { 'r' }
        let(:y) { 'o' }
      end
    end

    context 'varargs' do
      subject { "foobarbaz".method(:delete) }

      it_should_behave_like 'curry(varargs)' do
        let(:x) { 'r' }
        let(:y) { 'o' }
      end
    end
  end

  describe '#call' do
    subject { "aaa".method(:+) }

    it_should_behave_like 'call' do
      let(:x) { "foo" }
    end
    it_should_behave_like 'call(<)' do
      let(:x) { "foo" }
    end
  end

  describe 'ailases' do
    it_should_behave_like 'aliases' do
      subject { "aaa".method(:+) }
      let(:x) { "foo" }
    end

    it_should_behave_like 'aliases(varargs)' do
      subject { "foobarbaz".method(:delete) }
      let(:x) { 'r' }
      let(:y) { 'o' }
    end
  end
end
