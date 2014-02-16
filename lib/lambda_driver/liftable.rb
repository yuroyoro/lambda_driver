# -*- encoding : utf-8 -*-
module LambdaDriver::Liftable

  # Compose self and given function on the context-function.
  # The context-funciton is passed by `lift` method.
  #
  # This method returns composed funciton like bellow.
  #
  #  lambda{|args|  context.call(self, context.call(g,*args) }
  #
  # For example, set context-function that logging the result.
  #
  #   hash = {:a => "foo"}
  #   f = lambda{|x| x.length}
  #   g = lambda{|y| hash[y]}
  #
  #   ctx = lambda{|f,x|
  #     res = f.call(x)
  #     puts "result -> #{res}"
  #     res
  #   }
  #
  #   lifted = f.lift(ctx)
  #   h = lifted.compose_with_lifting g
  #
  #   h.(:a)
  #   #=> result -> foo
  #   #=> result -> 3
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
    if @lambda_driver_lifted
      ctx = @lambda_driver_liftable_context
      self.compose(g).tap{|f|
        f.instance_eval do
          @lambda_driver_lifted = true
          @lambda_driver_liftable_context = ctx
        end
      }
    else
      self.lift(DEFAULT_CONTEXT).compose_with_lifting(g)
    end
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
  DEFAULT_CONTEXT = LambdaDriver::Context[:maybe]

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
  def lift(ctx = DEFAULT_CONTEXT, &block)
    ctx = block_given? ? block : ctx
    ctx = case ctx
      when String, Symbol then LambdaDriver::Context[ctx]
      else ctx
    end

    # do not lift same context again
    return self if lambda_driver_lifted? && (ctx == lambda_driver_liftable_context)

    lambda{|*args| ctx.call(self, *args) }.tap{|f|
      f.instance_eval do
        @lambda_driver_lifted = true
        @lambda_driver_liftable_context = ctx
      end
    }
  end

  def lambda_driver_lifted?
    @lambda_driver_lifted
  end

  def lambda_driver_liftable_context
    @lambda_driver_liftable_context || DEFAULT_CONTEXT
  end

  def >=(g)
    g.to_proc.lift(lambda_driver_liftable_context).compose_with_lifting(self)
  end

  def self.included(klass)
    klass.send(:alias_method, :<=, :compose_with_lifting)
    klass.send(:alias_method, :ymsr, :lift)
  end
end
