class Symbol
  include LambdaDriver::Callable
  include LambdaDriver::Currying if RUBY_VERSION < '1.9.0'

  def to_method
    lambda{|obj| obj._(self) }
  end
  alias_method :-@, :to_method

  def to_method_with_args(*args)
    lambda{|obj| obj._(self).call(*args) }
  end
  alias_method :&, :to_method_with_args
end
