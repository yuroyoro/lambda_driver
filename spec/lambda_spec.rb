# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'lambda' do
  describe '#compose' do
    subject { lambda{|x| x.to_s} }

    it_should_behave_like 'composable'
  end

  describe '#compose_with_lifting' do
    subject { lambda{|x| x.mzero? ? x : x.to_s} }

    it_should_behave_like 'liftable'
  end

  describe '#with_args' do
    subject { lambda{|x, y, *z| [x, y] + z.to_a } }
    it_should_behave_like 'with_args'
  end

  describe '#flip' do
    context 'arity = 1' do
      subject { lambda{|x| [x] } }

      it_should_behave_like 'flip(arity=1)'
    end

    context 'arity > 1' do
      subject { lambda{|x, y| [x, y] } }

      it_should_behave_like 'flip'
    end

    context 'varargs' do
      subject { lambda{|*x| x } }

      it_should_behave_like 'flip(varargs)'
    end
  end

  describe '#curry' do
    subject { lambda{|x, y| [x, y] } }

    it_should_behave_like 'curry'

    context 'varargs' do
      subject { lambda{|*x| x } }

      it_should_behave_like 'curry(varargs)'
    end
  end

  describe '#call' do
    subject { lambda{|x| x.to_s + "_f"} }

    it_should_behave_like 'call'
    it_should_behave_like 'call(<)'
  end

  describe 'ailases' do
    subject { lambda{|x| x.to_s + "_f"} }

    it_should_behave_like 'aliases'
    it_should_behave_like 'aliases(varargs)' do
      subject { lambda{|*x| x } }
    end
  end
end
