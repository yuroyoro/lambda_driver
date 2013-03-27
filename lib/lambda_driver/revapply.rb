module LambdaDriver::Revapply
  def revapply(f = nil, &block)
    if f.nil? && (not block_given?)
      return lambda{|g=nil,&inner_block| self.revapply(g, &inner_block) }
    end

    block_given? ?  (yield self) : f.call(self)
  end
end
