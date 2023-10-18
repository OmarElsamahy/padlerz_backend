class String
  def to_bool
    return false if self.blank?
    ActiveModel::Type::Boolean.new.cast(self.downcase)
  end
end

class NilClass
  def to_bool
    false
  end
end

class TrueClass
  def to_bool
    true
  end
end

class FalseClass
  def to_bool
    false
  end
end

class Integer
  def to_bool
    self < 1 ? false : true
  end
end

class Float
  def to_bool
    self <= 0 ? false : true
  end
end

class Symbol
  def to_bool
    !self.to_s.empty?
  end
end
