class Node 
    include Comparable

    attr_accessor :data, :left, :right

    # def <=>(other) 
    #     data.size <=> other.data.size
    # end

    def initialize(data)
        @data = data
        @left = nil
        @right = nil
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

    # def inspect
    #     @data
    # end
end

class Tree 
    attr_accessor :data, :root

    def initialize(array)
        @data = array.sort.uniq
        @root = build_tree(data)
    end

    def build_tree(array)
        
        mid = ((array.size - 1) / 2)
        node = Node.new(array[mid])

        return nil if array.empty?

        node.left = build_tree((array[0...mid]))
        node.right = build_tree(array[(mid+1)...array.size])
        node
    end

    def insert(value, node = @root) 
        # Basically, we want to go through the tree using the compare operator. If the node is less than the root and we reach nil, create a new node at that point and it will become the left node of the previous number. Do the same for right.
        return nil if value == node.data

        if value < node.data
            if node.left.nil? 
                node.left = Node.new(value)
                @data.push(value)
                @data = @data.sort.uniq
            elsif !node.left.nil?
                insert(value, node.left)
            end
            
        else
            if node.right.nil?
                node.right = Node.new(value)
                @data.push(value)
                @data = @data.sort.uniq
            elsif !node.right.nil?
                insert(value, node.right)
            end
        end
    end

    def delete(value, node = root)
        return node if node.nil?
        p value, node.data
        if value < node.data
            node.left = delete(value, node.left)
        elsif value > node.data
            node.right = delete(value, node.right)
        else
            return node.right if node.left.nil?
            return node.left if node.right.nil?

            
            node.data = node.left.data
            node.left = delete(node.data, node.left)


        end
        node
    end

    def find(value, node = root)
        return node if node.nil? || node.data == value
        
        value < node.data ? find(value, node.left) : find(value, node.right) 
    end

    def level_order(node = root, queue = [])
        queue.push(node.left) if node.left
        queue.push(node.right) if node.right

        return if queue.empty?

        level_order(queue.shift, queue)
    end

    def inorder(node = root, array = [], &block)
        return if node.nil?
       
        inorder(node.left, array, &block) if node.left
        array.push(node.data)
        inorder(node.right, array, &block) if node.right

        if block_given?
            array = array.map do |x|
                yield x
            end 
        else 
            "No block was given"
        end
       
        array
    end

    def preorder(node = root, array = [], &block)
        return if node.nil?
       
        array.push(node.data)
        preorder(node.left, array, &block) if node.left
        preorder(node.right, array, &block) if node.right

        if block_given?
            array = array.map do |x|
                yield x
            end 
        else 
            "No block was given"
        end
       
        array
    end

    def postorder(node = root, array = [], &block)
        return if node.nil?
       
        postorder(node.left, array, &block) if node.left
        postorder(node.right, array, &block) if node.right
        array.push(node.data)

        if block_given?
            array = array.map do |x|
                yield x
            end 
        else 
            "No block was given"
        end
        array
    end

    def height(node = root)
        return -1 if node.nil?
        
        max_height = [height(node.left), height(node.right)].max + 1
        max_height
    end

    def depth(node = root, parent = root, edges = 0)
        return 0 if node == parent
        return -1 if parent.nil?

        if node < parent.data
            edges += 1
            depth(node, parent.left, edges)
        elsif node > parent.data
            edges += 1
            depth(node, parent.right, edges)
        else
            edges
        end     
    end

    def balanced?(node = root)
        return true if node.nil?

        left_height = height(node.left)
        right_height = height(node.right)

        return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

        false
    end

    def rebalance(node = root)
        make_tree = inorder(node)
        
        self.data = make_tree
        self.root = build_tree(data)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
end

my_tree_root = (Array.new(15) { rand(1..100) })

my_tree = Tree.new(my_tree_root)
my_tree.pretty_print

p my_tree.balanced?

p my_tree.preorder, my_tree.postorder, my_tree.inorder

10.times do 
    my_tree.insert(rand(101..200))
end

p my_tree.balanced?
my_tree.pretty_print

my_tree.rebalance
p my_tree
my_tree.pretty_print
p my_tree.balanced?

p my_tree.preorder, my_tree.postorder, my_tree.inorder
