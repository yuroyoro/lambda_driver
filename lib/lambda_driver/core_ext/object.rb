# -*- encoding : utf-8 -*-
class Object
  include LambdaDriver::Op::Proxy
  include LambdaDriver::Revapply
  include LambdaDriver::Disjunction
  include LambdaDriver::Mzero
end
