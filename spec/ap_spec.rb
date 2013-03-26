require 'spec_helper'

describe LambdaDriver::Ap do
  let(:object) { "foobarbaz" }
  let(:f) { lambda{|x| x * 2 } }

  describe '#ap'do
    context 'given none' do
      subject { object.ap }

      it { should be_a_kind_of Proc }
      it('obj.ap.call(f) should be f.call(obj)'){
        subject.call(f).should == f.call(object)
      }
      it('obj.ap.call{block} should be result of execute block with obj'){
        subject.call{|x| x * 3 }.should == (object * 3)
      }
      it('obj.ap.call(f){block} should be result of execute block with obj'){
        subject.call(f){|x| x * 3 }.should == (object * 3)
      }
    end

    context 'block given' do
      it('obj.ap{block} should be result of execute block with obj'){
        object.ap{|x| x * 3 }.should == (object * 3)
      }
    end

    context 'proc object given' do
      it('obj.ap(f) should be f.call(obj)'){
        object.ap(f).should == f.call(object)
      }
    end

    context 'block given and proc object given' do
      it('obj.ap.call(f){block} should be result of execute block with obj'){
        object.ap(f){|x| x * 3 }.should == (object * 3)
      }
    end
  end
end
