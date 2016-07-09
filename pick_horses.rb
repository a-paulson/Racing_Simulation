
races_list = [
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.5}],
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.5}],
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.5}]
]


races_list2 = [
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.25}, {h: 3, prob: 0.125}, {h: 4, prob: 0.1}, {h: 5, prob: 0.02}, {h: 6, prob: 0.005}],
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.25}, {h: 3, prob: 0.125}, {h: 4, prob: 0.1}, {h: 5, prob: 0.02}, {h: 6, prob: 0.005}],
  [{h: 1, prob: 0.5}, {h: 2, prob: 0.25}, {h: 3, prob: 0.125}, {h: 4, prob: 0.1}, {h: 5, prob: 0.02}, {h: 6, prob: 0.005}],
  [{h: 1, prob: 0.2}, {h: 2, prob: 0.18}, {h: 3, prob: 0.17}, {h: 4, prob: 0.16}, {h: 5, prob: 0.15}, {h: 6, prob: 0.14}],
  [{h: 1, prob: 0.2}, {h: 2, prob: 0.18}, {h: 3, prob: 0.17}, {h: 4, prob: 0.16}, {h: 5, prob: 0.15}, {h: 6, prob: 0.14}],
  [{h: 1, prob: 0.2}, {h: 2, prob: 0.18}, {h: 3, prob: 0.17}, {h: 4, prob: 0.16}, {h: 5, prob: 0.15}, {h: 6, prob: 0.14}]
]

# EQUALITY_DISTANCE = 0.01


def generate_tickets(races, number_of_tickets)
  tickets =[]
  pq = PriorityQueue.new

  first_ticket = Array.new(races.length) {0}
  first_ticket_prob = prob_of_ticket(races, first_ticket)

  # prob_ticket = 1
  # ticket_horses = []
  # races.each do |race|
  #   prob_ticket *= race[0][:prob]
  #   ticket_horses << 0
  #   # p prob_ticket
  # end

  # p prob_ticket
  pq.add(first_ticket_prob, first_ticket)
  # pq.add(key, value)
  # key is probability of ticket winning, value is the ticket as idxs


  until tickets.length >= number_of_tickets
    # p pq.queue
    current_ticket = pq.pop
    current_ticket[1].each_with_index do |horse, race_idx|
      next if races[race_idx][horse + 1].nil?
      next_ticket = current_ticket[1].dup
      next_ticket[race_idx] = next_ticket[race_idx] + 1

      prob_of_next_ticket = prob_of_ticket(races, next_ticket)
      pq.add(prob_of_next_ticket, next_ticket)
    end

    horses = current_ticket[1].map.with_index {|race, idx| races[idx][race][:h]}
    tickets << [current_ticket[0], horses]
  end

  tickets
end

def prob_of_ticket(races, ticket)
  # p races
  # p ticket
  prob_ticket = 1
  # p 'calc start'
  races.each_with_index do |race, idx|
    # p race[ticket[idx]][:prob]
    prob_ticket *= (1 / race[ticket[idx]][:prob])
  end
  # p 'outputs'
  # p prob_ticket
  # p ticket

  prob_ticket
end


class PriorityQueue
  def initialize
    @queue = []
  end

  def add(key, value)
    # p key
    @queue << [key, value]
  end

  def pop
    @queue = @queue.sort {|a,b| b[0] <=> a[0]}
    @queue.pop
  end

  def queue
    @queue
  end
end

out_tickets = generate_tickets(races_list2, 100)

p out_tickets
p out_tickets.inject(0) {|sum, ticket| sum += (1 / ticket[0])}


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
