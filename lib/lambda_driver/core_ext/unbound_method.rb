# -*- encoding : utf-8 -*-
class UnboundMethod
  alias_method :<, :bind
end
