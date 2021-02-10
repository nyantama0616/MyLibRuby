# 約数をすべて列挙
def make_divisors(num)
    result = []
    (1..Math.sqrt(num)).reverse_each do |x|
        if num % x == 0
            result << x
            result << num / x
        end
    end
    result.sort
end
