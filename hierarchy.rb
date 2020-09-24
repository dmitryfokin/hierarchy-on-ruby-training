# Представляет коллекцию элементов в виде иерархии
require 'securerandom'
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
    add_item_to_tree item.ref

    item
  end

  def to_json

  end
  
  def add_item_to_tree ref
    item = @items[ref]

    parent_from_tree = !item.ancestors.empty? ? @tree_nodes[item.ancestors[-1]] : @tree

    parent_from_tree[ref] = {}
    @tree_nodes[ref] = parent_from_tree[ref]
  end
end
