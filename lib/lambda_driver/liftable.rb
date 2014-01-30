# -*- encoding : utf-8 -*-
module LambdaDriver::Liftable

  # Compose self and given function on the context-function.
  # The context-funciton is passed by `lift` method.
  #
  # This method returns composed funciton like bellow.
  #
  #  lambda{|args|  context(self, g(*args)) }
  #
  # For example, set context-function that logging the result.
  #
  #   hash = {:a => "foo"}
  #   f = lambda{|x| x.length}
  #   g = lambda{|y| hash[y]}
  #
  #   ctx = lambda{|f,x|
  #     puts "g(x)    -> #{x}"
  #     y = f.call(x)
  #     puts "f(g(x)) -> #{y}"
  #     y
  #   }
  #
  #   lifted = f.lift(ctx)
  #   h = lifted.compose_with_lifting g
  #
  #   h.(:a)
  #   #=>  g(x)    -> foo
  #   #=>  f(g(x)) -> 3
  #   #=> 3
  #
  # if context-function does not given,
  # default behaivior is compose function with checking g(x) is mzoro
  #
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
    context = lambda_driver_liftable_context

    lambda{|*args| context.call(self.to_proc, g.to_proc.call(*args)) }.lift(context)
  end

  # This is a default context-function.
  # default behaivior is compose function with checking g(x) is mzoro
  #
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
  DEFAULT_CONTEXT = lambda{|f, x|
    mzero_method = x.respond_to?(:mzero?) ? :mzero? : :nil?
    x.send(mzero_method) ? x : f.call(x)
  }

  # Lift this function to the given context-function.
  # The lifted fucntion can compose other function with context-fucntion.
  #
  # The given context-fuction used by `compose_with_lifting`
  # to compose other fucntion.
  #
  # The context-funciton should recieve 2 arguments.
  #  - first one is a function that reciver function of `compose_with_lifting` method.
  #  - second arg is a result of g(x)
  #  -- g is a function passed to `compose_with_lifting`
  #
  def lift(g = DEFAULT_CONTEXT)
    @lambda_driver_liftable_context = g
    self
  end

  def lambda_driver_liftable_context
    @lambda_driver_liftable_context || DEFAULT_CONTEXT
  end

  def >=(g)
    g.to_proc.lift(lambda_driver_liftable_context) <= self
  end

  def self.included(klass)
    klass.send(:alias_method, :<=, :compose_with_lifting)
  end
end
