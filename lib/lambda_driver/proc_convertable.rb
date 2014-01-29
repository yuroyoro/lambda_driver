# -*- encoding : utf-8 -*-
module LambdaDriver::ProcConvertable
  def self.included(klass)
    klass.send(:alias_method, :+@, :to_proc)
  end
end
