# -*- encoding : utf-8 -*-
module LambdaDriver::WithArgs

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

  def self.included(klass)
    klass.send(:alias_method, :*,  :with_args)
  end
end
