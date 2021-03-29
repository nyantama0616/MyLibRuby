# ヒープ構造
class Heap
    attr_accessor :cont
    def initialize(&comp)
        @cont = []
        @comp = comp || proc {|a, b| a <=> b}
    end

    #   要素追加
    def add(x)
        @cont << x
        i = @cont.size - 1
        j = i.odd? ? i / 2 : i / 2 - 1

        while true
            break if j < 0
            if @comp.call(@cont[i], @cont[j]) < 0
                @cont[i], @cont[j] = @cont[j], @cont[i]
                i, j = j, j.odd? ? j / 2 : j / 2 - 1
            else
                break
            end
        end
    end

    #   要素取得
    def remove
        result = @cont.shift
        if temp = @cont.pop
            @cont.unshift(temp)

            # 要素取得後のヒープ再構築
            i = 0
            left = 1
            right = 2
            while true
                if @cont[left] && @cont[right]
                    if @comp.call(@cont[left], @cont[right]) <= 0 && @comp.call(@cont[left], @cont[i]) < 0
                        @cont[i], @cont[left] = @cont[left], @cont[i]
                        i = left
                        left, right = 2*left + 1, 2*left + 2
                    elsif @comp.call(@cont[right], @cont[left]) < 0 && @comp.call(@cont[right], @cont[i]) < 0
                        @cont[i], @cont[right] = @cont[right], @cont[i]
                        i = right
                        left, right = 2*right + 1, 2*right + 2
                    else
                        break
                    end
                elsif @cont[left] && @comp.call(@cont[left], @cont[i]) < 0
                        @cont[i], @cont[left] = @cont[left], @cont[i]
                        break
                else
                    break
                end
            end
        end
        result
    end

    #先頭要素を返す
    def peek
        @cont.first
    end

    #空かどうか確認
    def empty?
        @cont.empty?
    end
end



# 平衡二分探索木(ピボットツリー)(1...size)の値を格納できる (参考: https://qiita.com/Kiri8128/items/6256f8559f0026485d90)
class PibotTree
    attr_accessor :root, :size, :k, :comp

    def initialize(size, &comp) #場合に応じて、比較方法をブロックで渡す
        @size = size
        @k = (size > 3) ? Math.log2(size).ceil : Math.log2(size).floor + 1
        @root = Node.new(2**(@k - 1))
        set_pibot(@root)
        @comp = comp || proc {|a, b| a <=> b}
    end

    # @size個のノードにpibotをセット
    def set_pibot(node)
        return if node.pibot.odd?
        node.set_child
        set_pibot(node.left)
        set_pibot(node.right)
    end

    # 要素を追加
    def add(x)
        return if search(x)
        node = @root
        while node.value
            temp = [x, node.value].sort(&@comp)
            if @comp.call(x, node.pibot) < 0 || (@comp.call(x, node.pibot) == 0 && comp.call(node.value, node.pibot) < 0)
                x, node.value = temp
                node = node.left
            else
                node.value, x = temp
                node = node.right
            end
        end
        node.value = x
    end

    #　要素を取得
    def remove(x)
        if node = search(x)
            if !node.has_child?
                node.value = nil
                return
            end

            while node.has_child?
                if node.right && node.right.value
                    node.value, node.right.min.value = node.right.min.value, nil
                    node = node.right.min
                else
                    node.value, node.left.max.value = node.left.max.value, nil
                    node = node.left.max
                end
            end
        end
    end

    # 要素を探索(値ではなく、ノードを返す)
    def search(x)
        node = @root
        while node && node.value
            if @comp.call(x, node.value) < 0
                node = node.left
            elsif @comp.call(x, node.value) > 0
                node = node.right
            else 
                return node
            end
        end
    end
end

class Node
    attr_accessor :value, :pibot, :left, :right

    def initialize(pibot)
        @pibot = pibot
    end

    def set_child
        temp = lsb(@pibot) / 2
        @left = Node.new(@pibot - temp)
        @right = Node.new(@pibot + temp)
    end

    def lsb(x)
        i = 0
        # x == 0 or 巨大な数の場合、無限ループ
        while true
            return 2**i if x[i].eql?(1)
            i += 1
        end
    end

    # 最小ノードを探索
    def min
        node = self
        while node.left && node.left.value
            node = node.left
        end
        node
    end
    
    # 最大ノードを探索
    def max
        node = self
        while node.right && node.right.value
            node = node.right
        end
        node
    end

    def has_child?
        !!((@left || @right) && (@left.value || @right.value))
    end

end



# BIT
class BinaryIndexedTree
    attr_accessor :bits, :len
    
    # 数列aryの全要素が0以上である必要がある
    def initialize(ary)
        @bits = ary.map.with_index {|x, i| Bit.new(x, i + 1)}
        @len = ary.length
    end

    # すべての区間和を計算
    def set_interval_sum
        @bits.each_with_index do |bit, i|
            bit.interval_sum = bit.value
            d = 1
            while d < bit.lsb
                bit_ = @bits[i - d]
                bit.interval_sum += bit_.interval_sum
                d += bit_.lsb
            end
        end
    end

    # 値の更新
    def update_at(i, value)
        bit = @bits[i]
        diff = bit.value - value
        bit.value = value
        while i < len
            bit = bits[i]
            bit.interval_sum -= diff
            i += bit.lsb
        end
    end
    
    # a_iをvalueだけインクリメントする
    def increase_at(i, value)
        bit = @bits[i]
        bit.value += value
        while i < len
            bit = bits[i]
            bit.interval_sum += value
            i += bit.lsb
        end
    end

    # a_1 ~ a_iまでの総和を計算
    def calc_sum_at(i)
        result = 0
        while i >= 0
            bit = @bits[i]
            result += bit.interval_sum
            i -= bit.lsb
        end
        result
    end

     # a_1 ~ a_iまでの総和がx以下になるiの最大値
    def get_min_i(x)
        result = nil
        d = 2 ** Math.log2(@len).floor
        i = d - 1
        while bit = @bits[i]
            bit = @bits[i]
            d /= 2
            if calc_sum_at(i) <= x
                result = i
                i += d
            else
                i -= d
            end
            break if bit.lsb == 1
        end 
        result
    end

    # 確認用
    def show_bits
        p @bits.map {|x| x.value}
        p @bits.map {|x| x.interval_sum}
        p @bits.map {|x| x.lsb}
    end
end

class Bit
    attr_accessor :value, :interval_sum, :lsb

    def initialize(value, i)
        @value = value
        @lsb = i & -i
    end
end
