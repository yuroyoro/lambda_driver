# -*- encoding : utf-8 -*-
require 'spec_helper'

shared_examples_for 'liftable' do
  it { should respond_to :compose_with_lifting }
  it { should respond_to :>= }
  it { should respond_to :<= }
  it { should respond_to :ymsr}

  let(:x) { :foo }
  let(:y) { [1,2] }
  let(:z) { {:a => 1, :b => 2} }
  let(:g) { lambda{|x|
    if x.nil? || (x.respond_to?(:empty?) && x.empty?)
      raise "g called with nil arg"
    else
      (x.to_s * 2) + "_g"
    end
    }
  }
  let(:h) { lambda{|x| (x.to_s * 3) + "_h" } }

  context 'lift on default-context' do
    it('" f >= g" returns function that does not call g if args is mzero'){
      (subject >= g).should be_a_kind_of Proc
    }

    it('"(f >= g).call(nil) returns nil and does not call g'){
      (subject >= g).call(nil).should be_nil
    }
    it('"(f >= g).call(x) should be g(f(x))'){
      (subject >= g).call(x).should == g.call(subject.to_proc.call(x))
    }
    it('"(f >= g).call([]) returns [] and does not call g'){
      (subject >= g).call([]).should == []
    }
    it('"(f >= g).call([1,2]) should be g(f([1,2]))'){
      (subject >= g).call(y).should == g.call(subject.to_proc.call(y))
    }
    it('"(f >= g).call({}) returns {} and does not call g'){
      (subject >= g).call({}).should == {}
    }
    it('"(f >= g).call({:a => 1,:b => 2}) should be g(f({:a => 1,  :b => 2}))'){
      (subject >= g).call(z).should == g.call(subject.to_proc.call(z))
    }
  end

  context 'lift on given context' do
    let(:ctx) { lambda{|f,x| f.call(x) + "_ctx_" }}

    it(" f.lift(ctx) >= g returns funciton that compose with ctx"){
      (subject.lift(ctx) >= g).should be_a_kind_of Proc
    }
    it('"(f.lift(ctx) >= g).call(x) should be ctx(g, ctx(f, x))'){
      (subject.lift(ctx) >= g).call(x).should == ctx.call(g, ctx.call(subject.to_proc,x))
    }
    it('"(f.lift(ctx) >= g >= h).call(x) should be ctx(h, ctx(g, f(x)))'){
      (subject.lift(ctx) >= g >= h).call(x).should == ctx.call(h, ctx.call(g, ctx.call(subject.to_proc, x)))
    }
  end
end
