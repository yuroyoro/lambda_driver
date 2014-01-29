# -*- encoding : utf-8 -*-
module LambdaDriver::Liftable

  # compose self and give fuction with checking g(x) is mzero.
  # if g(x) is mzero, it does not call self and return g(x),
  # otherwise returns f(g(x)).
  #
  # mzero means the object is nil or emtpy
  #
  #   hash = {:a => "foo"}
  #   f = lambda{|y| y.length }
  #   g = lambda{|y| hash[y]}
  #   h = f.compose_with_lifting g
  #   h.(:a) # => 3
  #   h.(:b) # => nil (it does not called f)
  #
  # This method is aliased as `<=`.
  #
  #   f <= g # => f.compose_with_lifting(g)
  #
  def compose_with_lifting(g)
    lambda{|*args|
      result = g.to_proc.call(*args)
      mzero_method = result.respond_to?(:mzero?) ? :mzero? : :nil?
      result.send(mzero_method) ? result : self.to_proc.call(result)
    }
  end

  def >=(g)
    g.to_proc <= self
  end

  def self.included(klass)
    klass.send(:alias_method, :<=, :compose_with_lifting)
  end
end
