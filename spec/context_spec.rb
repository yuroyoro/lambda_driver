# -*- encoding : utf-8 -*-
require 'spec_helper'

describe LambdaDriver::Context do

  let(:f){ lambda{|x| x.to_s} }
  let(:g){ lambda{|x| x * 2} }

  describe LambdaDriver::Context::Identify do
    let(:ctx) { :identify }
    let(:x){ :foo }
    it("f.lift(:identify).call(x).should == f(x)"){
      f.lift(:identify).call(x).should == f.call(x)
    }

    it("(f.lift(:identify) >= g).call(x).should == g(f(x))"){
      (f.lift(:identify) >= g).call(x).should == g.call(f.call(x))
    }
  end

  describe LambdaDriver::Context::Maybe do
    let(:x){ :foo }

    it("f.lift(:maybe).call(nil).should be_nil"){
      f.lift(:maybe).call(nil).should be_nil
    }

    it("f.lift(:maybe).call(x).should f(x)"){
      f.lift(:maybe).call(x).should == f.call(x)
    }

    it("(f.lift(:maybe) >= g).call(nil).should be_nil "){
      (f.lift(:maybe) >= g).call(nil).should be_nil
    }

    it("(f.lift(:maybe) >= g).call(x).should == g(f(x))"){
      (f.lift(:maybe) >= g).call(x).should == g.call(f.call(x))
    }
  end

  describe LambdaDriver::Context::List do
    let(:x){ [:foo, :bar] }

    it("f.lift(:list).call([]).should == []"){
      f.lift(:list).call([]).should == []
    }

    it("f.lift(:list).call(x).should == x.map(&f)"){
      f.lift(:list).call(x).should == x.map(&f)
    }

    it("(f.lift(:list) >= g).call([]).should == (x.map(&f)).map(&g)"){
      (f.lift(:list) >= g).call([]).should == []
    }

    it("(f.lift(:list) >= g).call(x).should == (x.map(&f)).map(&g)"){
      (f.lift(:list) >= g).call(x).should == (x.map(&f)).map(&g)
    }
  end

  describe LambdaDriver::Context::Reader do
    let(:x){ 2 }
    let(:r){ 3 }

    let(:f){ lambda{|x| (ask + x).to_s} }
    let(:g){ lambda{|x| x * (ask)} }

    it("f.lift(:reader).call([r, x]).should == [r, f(x)]"){
      f.lift(:reader).call([r, x]).should == [r, (r + x).to_s]
    }

    it("(f.lift(:reader) >= g).call([r, x]).should == [r, g(f(x))]"){
      (f.lift(:reader) >= g).call([r, x]).should == [r, ((r + x).to_s) * r]
    }
  end

  describe LambdaDriver::Context::Writer do
    let(:w) { [:hoge] }
    let(:x) { :foo }
    let(:f){ lambda{|x| tell("bar_" + x.to_s); x.to_s } }
    let(:g){ lambda{|x| tell("baz_" + x); x * 2 } }

    it("f.lift(:writer).call([x, w]).should == [f(x), w]"){
      f.lift(:writer).call([x, w]).should == [x.to_s, w]
      w.should == [:hoge, "bar_foo"]
    }

    it("(f.lift(:writer) >= g).call([r, x]).should == [r, g(f(x))]"){
      (f.lift(:writer) >= g).call([x, w]).should == [(x.to_s) * 2, w]
      w.should == [:hoge, "bar_foo", "baz_foo"]
    }
  end
end
