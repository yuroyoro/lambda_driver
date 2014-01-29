# -*- encoding : utf-8 -*-
require 'spec_helper'

describe LambdaDriver::Revapply do
  let(:object) { "foobarbaz" }
  let(:f) { lambda{|x| x * 2 } }

  describe '#revapply'do
    context 'given none' do
      subject { object.revapply }

      it { should be_a_kind_of Method }
      it('obj.revapply.call(f) should be f.call(obj)'){
        subject.call(f).should == f.call(object)
      }
      it('obj.revapply.call{block} should be result of execute block with obj'){
        subject.call{|x| x * 3 }.should == (object * 3)
      }
      it('obj.revapply.call(f){block} should be result of execute block with obj'){
        subject.call(f){|x| x * 3 }.should == (object * 3)
      }
    end

    context 'block given' do
      it('obj.revapply{block} should be result of execute block with obj'){
        object.revapply{|x| x * 3 }.should == (object * 3)
      }
    end

    context 'proc object given' do
      it('obj.revapply(f) should be f.call(obj)'){
        object.revapply(f).should == f.call(object)
      }
    end

    context 'block given and proc object given' do
      it('obj.revapply.call(f){block} should be result of execute block with obj'){
        object.revapply(f){|x| x * 3 }.should == (object * 3)
      }
    end
  end
end
