class Error
    
  attr_accessor :code, :field, :fields
  
  def initialize(code=nil, field=nil)
      self.code = code
      self.field = field
  end
  
end
