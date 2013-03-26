module LambdaDriver::Callable

  def call(*args, &block)
    if block_given?
      self.to_proc.call(*args, &block)
    else
      self.to_proc.call(*args)
    end
  end

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

  # Returns partially applied function that has 2nd and more parameters
  # fixed by given *args.
  #
  #   f = lamdba{|x, y, z| [x, y, z]}
  #   h = f.with_args(:a, :b)
  #   h.(:c) # => [:c, :a, :b]
  #
  # This method is aliased as `*`.
  #
  #   f * :foo  # => f.with_args(:foo)
  #
  def with_args(*args)
    lambda{|v|
      self.to_proc.call(*([v] + args))
    }
  end

  # Returns function whose parameter order spawed 1st for 2nd.
  # A result of filped fuction is curried by Proc#curry.
  #
  #   f = lamdba{|x, y, z| [x, y, z]}
  #   h = f.flip
  #   h.(:a).(:b).(:c) # => [:b, :a, :c]
  #
  # If arguments is var-args, pass explicitly arity to curring.
  #
  #   p = Proc.new{|*args| args.inspect }
  #   p.flip(3).call(:a).(:b).(:c)      # => "[:b, :a, :c]"
  #   p.flip(4).call(:a).(:b).(:c).(:d) # => "[:b, :a, :c, :d]"
  #
  # If arity is 0 or 1, flip returns itself.
  #
  # This method is aliased as `~@`.
  #
  #   ~f # => f.filp
  #
  def flip(arity = nil)
    f = self.to_proc
    return self if (0..1).include?(f.arity)
    return self if f.arity == -1 && arity.nil?

    curried = f.curry(arity)
    lambda{|x|
      lambda{|y|
        g = curried[y]
        (g.respond_to? :call) ? g[x] : g
      }
    }
  end

  def curry(arity = nil)
    self.to_proc.curry(arity)
  end

  def self.included(klass)
    klass.send(:alias_method, :+@, :to_proc)
    klass.send(:alias_method, :<,  :call)
    klass.send(:alias_method, :<<, :compose)
    klass.send(:alias_method, :*,  :with_args)
    klass.send(:alias_method, :~@, :flip)
    klass.send(:alias_method, :%, :curry)
  end
end
