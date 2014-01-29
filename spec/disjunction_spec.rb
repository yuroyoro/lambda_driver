# -*- encoding : utf-8 -*-
require 'spec_helper'

describe LambdaDriver::Disjunction do
  let(:obj) { "foobarbaz" }
  let(:f) { lambda{|x| x * 2 } }

  describe '#disjunction'do
    context 'f(obj) returns nil' do
      context 'given none' do
        subject { obj.disjunction }

        it { should be_a_kind_of Method }

        it('obj.disjunction.call(f) should be obj'){
          subject.call(lambda{|x| nil}).should == obj
        }
        it('obj.disjunction.call{block} should be obj'){
          subject.call{nil}.should == obj
        }
        it('obj.disjunction.call(f){block} should obj'){
          subject.call(f){nil}.should == obj
        }
      end

      context 'block given' do
        it('obj.disjunction{block} should be result of execute block with obj'){
          obj.disjunction{nil}.should == obj
        }
      end

      context 'proc object given' do
        it('obj.ap(f) should be f.call(obj)'){
          obj.disjunction(lambda{|x| nil}).should == obj
        }
      end

      context 'block given and proc object given' do
        it('obj.ap.call(f){block} should be result of execute block with obj'){
          obj.disjunction(f){nil}.should == obj
        }
      end
    end

    context 'f(obj) does not returns nil' do
      context 'given none' do
        subject { obj.disjunction }

        it { should be_a_kind_of Method }

        it('obj.disjunction.call(f) should be obj'){
          subject.call(f).should == f.call(obj)
        }
        it('obj.disjunction.call{block} should be result of execute block with obj'){
          subject.call{|x| x * 3 }.should == obj * 3
        }
        it('obj.disjunction.call(f){block} should be result of execute block with obj'){
          subject.call(f){|x| x * 3 }.should == obj * 3
        }
      end

      context 'block given' do
        it('obj.disjunction{block} should be result of execute block with obj'){
          obj.disjunction{|x| x * 3 }.should == (obj * 3)
        }
      end

      context 'proc object given' do
        it('obj.ap(f) should be f.call(obj)'){
          obj.disjunction(f).should == f.call(obj)
        }
      end

      context 'block given and proc object given' do
        it('obj.ap.call(f){block} should be result of execute block with obj'){
          obj.disjunction(f){|x| x * 3 }.should == (obj * 3)
        }
      end
    end
  end
end
