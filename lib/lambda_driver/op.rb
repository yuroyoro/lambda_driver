# -*- encoding : utf-8 -*-
module LambdaDriver::Op
  module Proxy
    def _(method = nil)
      method ? ::LambdaDriver::Op.method_or_lambda(self, method) : OpProxy.new(self)
    end
  end

  def method_or_lambda(obj, method)
    (obj.respond_to?(method) && obj.method(method)) ||
      lambda{|*args| obj.__send__(method, *args) }
  end
  module_function :method_or_lambda

  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^(__|object_id)/ }
  end

  class OpProxy < (RUBY_VERSION < '1.9.0' ? BlankSlate : BasicObject)
    def initialize(obj)
      @obj = obj
    end

    def call(method)
      ::LambdaDriver::Op.method_or_lambda(@obj, method)
    end

    def method_missing(method)
      ::LambdaDriver::Op.method_or_lambda(@obj, method)
    end
  end
end
