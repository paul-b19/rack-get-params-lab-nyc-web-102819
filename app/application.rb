class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart  = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    req.path.match(/add/)
    search = req.params["item"]
    if @@items.include?(search)
      @@cart << search
      resp.write "added #{search}"
    else
      resp.write "We don't have that item"
    end

    req.path.match(/cart/)
    if @@cart.count > 0
      @@cart.each do |item|
        resp.write "#{item}\n"
      end
    else
      resp.write "Your cart is empty"
    end

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
