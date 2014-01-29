# -*- encoding : utf-8 -*-
class Symbol
  include LambdaDriver::Callable
  include LambdaDriver::Composable
  include LambdaDriver::WithArgs
  include LambdaDriver::Flipable
  include LambdaDriver::ProcConvertable
  include LambdaDriver::Currying
  include LambdaDriver::Liftable

  def to_method
    lambda{|obj| obj._(self) }
  end
  alias_method :-@, :to_method

  def to_method_with_args(*args)
    lambda{|obj| obj._(self).call(*args) }
  end
  alias_method :&, :to_method_with_args
end
