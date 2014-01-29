class Proc
  include LambdaDriver::Callable
  include LambdaDriver::Composable
  include LambdaDriver::WithArgs
  include LambdaDriver::Flipable
  include LambdaDriver::ProcConvertable
  include LambdaDriver::Currying
  include LambdaDriver::Liftable
end
