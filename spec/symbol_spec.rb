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

    it_should_behave_like 'call'
  end

  describe 'ailases' do
    subject { :to_s }

    it_should_behave_like 'aliases'

    it_should_behave_like 'aliases(varargs)' do
      subject { :product }
      let(:x) { [:bar] }
      let(:y) { [:foo] }
    end
  end
end
