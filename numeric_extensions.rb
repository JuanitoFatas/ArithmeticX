class Numeric
  def plus?
    self > 0
  end

  def minus?
    !plus?
  end

  def positive?
    plus?
  end

  def negative?
    minus?
  end

  def non_positive?
    self <= 0
  end

  def non_zero?
    !self.zero?
  end

  def half
    Rational(self, 2)
  end

  def double
    self * 2
  end

  def square
    self * self
  end

  def cube
    self * self * self
  end
end
