# -*- encoding : utf-8 -*-
module LambdaDriver::Composable
  # Returns new lambda which composed self and given function.
  # A composed proc called with args, executes `self.(g(*args)).
  #
  #   f = lamdba{|x| x.to_s }
  #   g = lambda{|y| y.length }
  #   h = f compose g
  #   h.(:hoge) # => 4
  #
  # This method is aliased as `<<`.
  #
  #   f << g # => f.compose(g)
  #
  def compose(g)
    lambda{|*args| self.to_proc.call(g.to_proc.call(*args)) }
  end

  # g compose self
  def >>(g)
    g.to_proc << self
  end

  def self.included(klass)
    klass.send(:alias_method, :<<, :compose)
  end
end
