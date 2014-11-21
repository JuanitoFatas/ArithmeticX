module Math
  # Returns the number of bits needed to represent integer in binary two's-complement format.
  def self.integer_length n
    _n = (n < 0) ? -n : n+1
    Math.log2(_n).ceil
  end

  # Compute the number of digits in the non-negative integer `n` in
  # base `base`. Base is 10 by default.
  def self.digit_count n, base = 10
    raise Class.new(StandardError), "The assertion (n >= 0) failed with n = #{n}." if n < 0

    return 1 if n.zero?
    return integer_length(n) if base == 2

    approx = ((integer_length n) / Math.log2(base)).ceil
    exponent = base ** (approx - 1)
    if exponent > n
      approx - 1
    else
      approx
    end
  end

  # Compute `lower * (lower+1) * ... * (upper-1) * upper`.
  def self.range_product lower, upper
    if lower <= upper
      case (upper - lower)
      when 0 then lower
      when 1 then lower * upper
      else
        mid = (lower + upper) / 2
        range_product(lower, mid) * range_product(mid + 1, upper)
      end
    else
      raise Class.new(StandardError), "The assertion (lower <= upper) failed with lower = #{lower}, upper = #{upper}."
    end
  end

  # Compute the factorial of `n`, where `n! = 1 * 2 * ... * n`.
  def self.factorial n
    return 1 if n.zero?
    range_product 1, n
  end

  # Binomial coefficient of `n` and `k`.
  def self.binomial_coefficient n, k
    raise Class.new(StandardError), "The assertion (n >= k) failed with n = #{n}, k = #{k}." if n < k

    return 1 if k.zero? || n == k

    n_k = n - k

    return n if n_k == 1

    if k < n_k
      (range_product(n_k+1, n)/(factorial k)).floor
    else
      (range_product(k+1, n)/(factorial n_k)).floor
    end
  end

  # Yield the number of combinations of `n` objects partitioned into m
  # groups (for `ks = (k_1, ..., k_m)`) with `k_i` objects in a respective
  # group (i.e., group *m* has `k_m` objects).
  def self.multinomial_coefficient n, *ks
    sorted = ks.sort
    sums   = _collect_reduce(:+, sorted)

    sorted.zip(sums).reject do |collection|
      collection.any? { |element| element.nil? }
    end.map do |no_nil_collection|
      binomial_coefficient(no_nil_collection[1], no_nil_collection[0])
    end.reduce(&:*)
  end

  def self._collect_reduce meth, arr
    0.upto(arr.size-1).map { |i| arr[0..i].reduce(&meth) }
  end
  private_class_method :_collect_reduce
end
