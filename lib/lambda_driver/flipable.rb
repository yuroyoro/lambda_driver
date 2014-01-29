# -*- encoding : utf-8 -*-
module LambdaDriver::Flipable
  # Returns function whose parameter order spawed 1st for 2nd.
  # A result of filped fuction is curried by Proc#curry.
  #
  #   f = lamdba{|x, y, z| [x, y, z]}
  #   h = f.flip
  #   h.(:a).(:b).(:c) # => [:b, :a, :c]
  #
  # If arguments is var-args, pass explicitly arity to curring.
  #
  #   p = Proc.new{|*args| args.inspect }
  #   p.flip(3).call(:a).(:b).(:c)      # => "[:b, :a, :c]"
  #   p.flip(4).call(:a).(:b).(:c).(:d) # => "[:b, :a, :c, :d]"
  #
  # If arity is 0 or 1, flip returns itself.
  #
  # This method is aliased as `~@`.
  #
  #   ~f # => f.filp
  #
  def flip(arity = nil)
    f = self.to_proc
    return self if (0..1).include?(f.arity)
    return self if f.arity == -1 && arity.nil?

    curried = f.curry(arity)
    lambda{|x|
      lambda{|y|
        g = curried[y]
        (g.respond_to? :call) ? g[x] : g
      }
    }
  end

  def self.included(klass)
    klass.send(:alias_method, :~@, :flip)
  end
end
