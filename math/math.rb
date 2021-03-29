# 約数全列挙
def make_divisors(num)
  result = []
  (1..Math.sqrt(num)).reverse_each do |x|
    if num % x == 0
      result << x
      result << num / x
    end
  end
  result.uniq.sort #状況に応じて、uniqを外す
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
def to_easy!(rational_array)
  x = rational_array.inject(1) {|r, v| r.lcm(v.denominator)}
  rational_array = rational_array.map {|a| (a * x).to_i}
end

# 最頻値を求める(ソート済みの配列を渡す)
def mode(array, &comp)
  comp = comp || proc {|a, b| a <=> b}
  
  result = array[0]
  count_max = 0
  
  count = 0
  (1...array.size).each do |i|
    if comp.call(array[i], array[i - 1]).eql?(0)
      count += 1
    else
      if count > count_max
        count_max = count
        result = array[i - 1]
      end
      count = 0
    end
  end
  
  if count > count_max
        count_max = count
        result = array[-1]
  end

  result
end  

# 中央値を求める（ソート済みの配列を渡す）
def midian(sorted_array)
    len = sorted_array.length
    if len < 2
        return sorted_array[0]
    end

    if len.even?
        (sorted_array[len / 2] + sorted_array[len / 2 - 1]) / 2
    else
        sorted_array[len / 2]
    end
end

# 組み合わせの数を計算
def binomial(n, r)
  [r.times.inject(1) {|a, b| a * (n - b)} / (1..r).inject(1, :*), 0].max
end  



# -------------------- ２点間系 ----------------------

# ユークリッド距離 or マンハッタン距離
def dist(m1, m2, mh: false)
  if mh
    (m1[0] - m2[0]).abs + (m1[1] - m2[1]).abs #マンハッタン
  else
    Math.hypot(m1[0] - m2[0], m1[1] - m2[1]) # ユークリッド
  end
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

# ----チェック系----

# 整数判定
def int?(num)
  num - num.to_i.eql?(0)
end

# ------雑魚関数-----

# 数字を日本語へ(ex: 15000 →　1万5000)
def to_j(num)
    list = %w(万 億 兆 京 垓 杼 穣 溝 潤 正 載 極 恒河沙 阿僧祇 那由他 不可思議 無量大数)
    d = Math.log10(num).floor + 1
    num = num.to_s.reverse
    p num
    result = ""
    temp = []
    d.downto(1) do |i|
    temp << num[i - 1]
        if i % 4 == 1 && i != 1
            p temp
            result += temp.join.to_i.to_s + list[i / 4 - 1]
            temp.clear
        end
    end

    result += temp.join.to_i.to_s unless temp.all? {|c| c == "0"}
    result
end

  # 符号取得
  def sign(x)
      if x > 0
          1 
      elsif x < 0
          -1
      else
          0
      end
  end
