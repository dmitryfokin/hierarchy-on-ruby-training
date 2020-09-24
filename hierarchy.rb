# Представляет коллекцию элементов в виде иерархии
require 'securerandom'
require 'json'

require './hierarchy-item'

class Hierarchy
  attr_accessor :items
  attr_accessor :tree
  attr_accessor :tree_nodes

  def initialize options={}
    @name = options[:name] || ''
    @description = options[:description] || ''
    @items = {}
    @tree = {}
    @tree_nodes = {}
  end

  def create_item parent=nil, name='-'
    options = {
      ref: SecureRandom.uuid,
      name: name,
      parent: parent
    }
    
    item = HierarchyItem.new options
    @items[item.ref] = item
    add_item_to_tree item

    item
  end

  def recursion_action(item)
    arr_items = []

    if item.nil?
      @tree.keys.each { |key| [arr_items << key, nil]}
    else
      arr_items << [item.ref, nil]
    end

    # рекурсия на базе массивов, позволяет сделать сразу срез дерева по одному уровню иерархии
    while !arr_items.empty?
      new_arr_items = []
      arr_items.each do |i|
        # тут обрабатываем только i
        yield(@items[i[0]])

        @tree_nodes[i[0]].keys.each do |j|
          new_arr_items << [j, i]
        end
      end

      arr_items = new_arr_items
    end

  end

  def to_json
    # tree_items = {}
    # arr_items = []
    #
    # @tree.keys.each do |key|
    #   tree_items[@items[key]] = {}
    #
    #   arr_items << @tree_nodes[key] if !@tree[key].empty?
    # end
    #
    # # puts tree_items.inspect
    # puts arr_items.inspect
    #
    #
    # while !arr_items.empty?
    #   new_arr_items = []
    #   arr_items.each do |i|
    #     i.keys.each {|j| puts j.inspect}
    #
    #     if !@items[j].empty?
    #       tree_items[]
    #     end
    #
    #   end
    #
    #   arr_items = new_arr_items
    # end
  end

  def add_item_to_tree item
    parent_from_tree = !item.ancestors.empty? ? @tree_nodes[item.ancestors[-1]] : @tree

    parent_from_tree[item.ref] = {}
    @tree_nodes[item.ref] = parent_from_tree[item.ref]
  end

  def move_item_to item, parent
    exit if parent.ancestors.include?(item.ref) # ошибка: элемент нельзя перенести ниже в свою же ветку

    old_parent = @items[item.ancestors[-1]]

    @tree_nodes[parent.ref][item.ref] = @tree_nodes[old_parent.ref][item.ref]
    @tree_nodes[old_parent.ref].delete(item.ref)

    item.new_parent parent

    # нужно пройтись по всем подчиненным и переписать родителей
    recursion_action(item) do |selected_item|
      if item != selected_item
        selected_item.new_parent @items[selected_item.ancestors[-1]]
      end
    end
  end
end
