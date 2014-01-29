# -*- encoding : utf-8 -*-
require 'spec_helper'

shared_examples_for 'composable' do
  it { should respond_to :to_proc}
  it { should respond_to :>> }
  it { should respond_to :<< }
  it { should respond_to :compose }

  let(:x) { :foo }
  let(:y) { 12 }
  let(:g) { lambda{|x| (x.to_s * 2) + "_g" } }

  it('" f >> g" returns g(f)'){
    (subject >> g).should be_a_kind_of Proc
  }
  it('"(f >> g).call(x)" should be g(f(x))'){
    (subject >> g).call(x).should == g.call(subject.to_proc.call(x))
  }

  it('" f << g" returns g(f)'){
    (subject << g).should be_a_kind_of Proc
  }
  it('"(f << g).call(x)" should be f(g(x))'){
    (subject << g).call(y).should == subject.to_proc.call(g.call(y)) }
end

shared_examples_for 'with_args' do
  it { should respond_to :with_args }
  it { should respond_to :*}

  let(:x) { :foo }
  let(:y) { :bar }
  let(:z) { :baz }

  it('" f.with_args(x) returns proc which is partaily appied arguments'){
    subject.with_args(y).should be_a_kind_of Proc
  }

  it('" f.with_args(y).call(x)" should be f(x, y)'){
    puts x.inspect
    subject.with_args(y).call(x).should == subject.to_proc.call(x, y)
  }

  it('" f.with_args(*args).call(x)" should be f(x, *args)'){
    subject.with_args(y, z).call(x).should == subject.to_proc.call(x, y, z)
  }

  it('" f * x returns proc which is partaily appied arguments'){
    (subject * y).should be_a_kind_of Proc
  }

  it('" (f * y).call(x)" should be f(x, y)'){
    (subject * y).call(x).should == subject.to_proc.call(x, y)
  }
end

shared_examples_for 'flip' do
  it { should respond_to :flip }
  it { should respond_to :~}

  let(:x) { :foo }
  let(:y) { :bar }

  it(' f.flip returns function whose parameter order swaped 1st for 2nd.'){
    subject.flip.should be_a_kind_of Proc
  }

  it(' f.flip.call(x) returns proc ') {
    subject.flip.call(y).should be_a_kind_of Proc
  }
  it(' f.flip.call(x).call(y) should be (y,x)'){
    subject.flip.call(y).call(x).should == subject.to_proc.call(x, y)
  }

  it(' ~f returns function whose parameter order swaped 1st for 2nd.'){
    (~subject).should be_a_kind_of Proc
  }

  it(' ~f.call(x) returns proc ') {
    (~subject).call(y).should be_a_kind_of Proc
  }
  it(' ~f.call(x).call(y) should be (y,x)'){
    (~subject).call(y).call(x).should == subject.to_proc.call(x, y)
  }
end

shared_examples_for 'flip(arity=1)' do
  let(:x) { :foo }
  let(:y) { :bar }

  it(' f.flip returns itself'){
    subject.flip.should == subject
  }

  it(' f.flip.call(x) returns proc ') {
    subject.flip.to_proc.call(y) == subject.to_proc.call(y)
  }
end

shared_examples_for 'flip(varargs)' do
  let(:x) { :foo }
  let(:y) { :bar }

  it('f.flip returns itself'){
    subject.flip.should == subject
  }

  it('f.flip(2).call(x) returns proc ') {
    subject.flip(2).call(y) == subject.to_proc.call(y)
  }

  it('~f.flip(2).call(x).call(y) should be f.call(y,x)'){
    subject.flip(2).call(y).call(x).should == subject.to_proc.call(x, y)
  }
end

shared_examples_for 'curry' do
  it { should respond_to :curry}
  it { should respond_to :%}

  let(:x) { :foo }
  let(:y) { :bar }

  it('f.curry returns curried function'){
    subject.curry.should be_a_kind_of Proc
  }

  it('f.curry.call(x) returns proc ') {
    subject.curry.call(y).should be_a_kind_of Proc
  }
  it('f.curry.call(x).call(y) should be f.call(x,y)'){
    subject.curry.call(x).call(y).should == subject.to_proc.call(x, y)
  }
end

shared_examples_for 'curry(varargs)' do
  let(:x) { :foo }
  let(:y) { :bar }

  it('f % 2 returns curried function'){
    (subject % 2).should be_a_kind_of Proc
  }

  it('(f % 2).call(x) returns proc ') {
    (subject % 2).call(y).should be_a_kind_of Proc
  }
  it('(f % 2).call(x).call(y) should be f.call(x,y)'){
    (subject % 2).call(x).call(y).should == subject.to_proc.call(x, y)
  }
end

shared_examples_for 'call' do
  it { should respond_to :call}

  let(:x) { :foo }

  it('f.call(x) == f.call(x)'){
    subject.call(x).should == subject.call(x)
  }
end

shared_examples_for 'call(<)' do
  it { should respond_to :<}

  let(:x) { :foo }

  it('(f < x) == f.call(x)'){
    (subject < x).should == subject.to_proc.call(x)
  }
end

shared_examples_for 'aliases' do
  let(:x) { :foo }
  let(:y) { 12 }
  let(:g) { lambda{|x| (x.to_s * 2).to_s + "_g" } }

  it('(~f < x) should be f.flip.call(x)'){
    (~subject < x).should == subject.flip.to_proc.call(x)
  }

  it('(f << g < x) should f.compose(g).call(x)'){
    (subject << g < x).should == subject.compose(g).call(x)
  }

  it('(f >> g < x) should g.compose(f).call(x)'){
    (subject >> g < x).should == g.compose(subject).call(x)
  }
end

  # require 'lambda_driver'
  # x, y, g = [:foo, 12, lambda{|x| (x.to_s * 2).to_s + "_g" }]
  # subject = Proc.new{|*x| x]

shared_examples_for 'aliases(varargs)' do
  let(:x) { :foo }
  let(:y) { 12 }
  let(:g) { lambda{|x| (x.to_s * 2).to_s + "_g" } }

  it('(f % 2 * y << g < x) should be f.curry(2).compose(g).call(x)'){
    ((subject % 2 < y) << g < x).should == subject.curry(2).call(y).compose(g).call(x)
  }

  it('(f.flip(2) * y << g < x) should be f.flip(2).compose(g).call(x)'){
    ((subject.flip(2) < y) << g < x).should == subject.flip(2).call(y).compose(g).call(x)
  }
end
