class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[count - 1] = @store[count - 1], @store[0]
    out_val = @store.pop
    BinaryMinHeap.heapify_down(@store, 0, @store.length, &@prc)
    out_val
  end

  def peek
    @store[0]
  end

  def push(val)
    @store.push(val)
    @store = BinaryMinHeap.heapify_up(@store, count - 1, count, &@prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    children = [2 * parent_index + 1, 2 * parent_index + 2]
    children.select {|child| child < len}
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new {|a,b| a <=> b}
    children = child_indices(len, parent_idx)
    return array if children.empty?
    if children.length == 1
      priority_child = children[0]
    else
      comp = prc.call(array[children[0]], array[children[1]])
      priority_child = comp == -1 ? children[0] : children[1]
    end
    if prc.call(array[parent_idx], array[priority_child]) == 1
      array[parent_idx], array[priority_child] = array[priority_child], array[parent_idx]
      heapify_down(array, priority_child, len, &prc)
    end
    array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new {|a,b| a <=> b}
    return array if child_idx == 0
    parent_idx = parent_index(child_idx)
    if prc.call(array[parent_idx], array[child_idx]) == 1
      array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
      heapify_up(array, parent_idx, len, &prc)
    end
    array
  end
end
