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

    while true
        j = i / 2
        if @comp.call(@cont[i], @cont[j]) < 0
            @cont[i], @cont[j] = @cont[j], @cont[i]
            i, j = j, j / 2
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
end

#-------------------------------------------------

# 平衡二分探索木(ピボットツリー)(1...size)の値を格納できる
class PibotTree
    attr_accessor :root, :size, :k, :comp

    def initialize(size, &comp)
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
            else #@comp.call(x, node.pibot) > 0 || (@comp.call(x, node.pibot) == 0 &&  comp.call(node.value, node.pibot) > 0)
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

# ------------------
