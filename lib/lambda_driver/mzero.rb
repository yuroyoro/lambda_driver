# -*- encoding : utf-8 -*-
module LambdaDriver::Mzero
  def mzero?
    mzero_method = self.respond_to?(:empty?) ? :empty? : :nil?
    self.send(mzero_method)
  end
end
