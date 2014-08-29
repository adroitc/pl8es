module Paypal
  module NVP
    class Request
      def post_with_debugger(method, params = {})
        response = post_without_debugger(method, params)
        puts <<-DEBUG
#{method}
==========
#{params.to_query}
----------
#{response}
==========

DEBUG
        response
      end
      alias_method_chain :post, :debugger
    end
  end
end