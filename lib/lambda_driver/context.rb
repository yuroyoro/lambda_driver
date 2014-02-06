# -*- encoding : utf-8 -*-
module LambdaDriver::Context

  Identify = lambda{|f, x| f.call(x) }

  Maybe = lambda{|f, x|
    mzero_method = x.respond_to?(:mzero?) ? :mzero? : :nil?
    x.send(mzero_method) ? x : f.call(x)
  }

  List = lambda{|f, x| x.map(&f) }

  Reader = lambda{|f, (r, x)|
    # set reader env to thread local
    Thread.current[:lambda_driver_reader_ctx_ask] = r
    # define ask method to access context of reader
    f.binding.eval(<<-CODE)
      def ask
        Thread.current[:lambda_driver_reader_ctx_ask]
      end
    CODE

    begin
      [r, f.call(x)]
    ensure
      # tear down reader context
      Thread.current[:lambda_driver_reader_ctx_ask] = nil
      f.binding.eval("undef ask")
    end
  }

  Writer = lambda{|f, (x, w)|
    pool = w || []

    # set writer pool to thread local
    Thread.current[:lambda_driver_writer_ctx_pool] = pool
    # define tell method to write log to context
    f.binding.eval(<<-CODE)
      def tell(s)
        pool = Thread.current[:lambda_driver_writer_ctx_pool]
        pool <<  s
      end
    CODE

    begin
      [f.call(x), pool]
    ensure
      # tear down reader context
      Thread.current[:lambda_driver_writer_ctx_pool] = nil
      f.binding.eval("undef tell")
    end
  }

  def self.[](name)
    name = name.to_s.capitalize
    const_defined?(name) && const_get(name)
  end

end
