module LambdaDriver::Op
  def op(operator)
  end
  class BlankSlate
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  end
end
