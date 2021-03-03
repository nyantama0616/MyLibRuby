# 約数全列挙
def make_divisors(num)
  result = []
  (1..Math.sqrt(num)).reverse_each do |x|
    if num % x == 0
      result << x
      result << num / x
    end
  end
  result.uniq.sort
end

# 度数法　→　弧度法
def radians(angle)
  (angle / 180.0) * Math::PI
end

# 弧度法 → 度数法
def degree(angle)
  angle * 180
end

# いもす法！
def imos!(array)
  sum = 0
  array.each_with_index do |x, i|
      sum += x
      array[i] = sum
  end
end


#配列の各要素の分母を払う(最も簡単な整数にする)
def to_easy(array)
  x = array.inject(1) {|r, v| r.lcm(v.denominator)}
  array = array.map {|a| (a * x).to_i}
end


# -------------------- ２点間系 ----------------------

# 距離
def dist(m1, m2)
  Math.hypot(m1[0] - m2[0], m1[1] - m2[1])
end

# ２点を通る直線の方程式(ax + bx = c)
def equ_2(p1, p2)
  if p1[0] == p2[0]
    result = [1, 0, p1[0]]
  else
    a =  -1 * ((p2[1] - p1[1]).to_r / (p2[0] - p1[0]).to_r)
    b = 1
    c = a * p1[0] + p1[1]
    result = [a, b, c]
  end
  to_easy(result)
end





# -------- 数学じゃないやつ ------------
