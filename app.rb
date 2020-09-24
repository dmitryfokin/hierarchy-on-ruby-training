require 'securerandom'
require './hierarchy'

puts 'Приложение, Иерархия!'
puts '=' * 80

tree1 = Hierarchy.new(name:'tree1')

n_1 = tree1.create_item(nil, 'n_1' )
n_1_1 = tree1.create_item(n_1, 'n_1_1')
n_1_1_1 = tree1.create_item(n_1_1, 'n_1_1_1')
n_1_1_1_1 = tree1.create_item(n_1_1_1, 'n_1_1_1_1')
n_1_1_1_2 = tree1.create_item(n_1_1_1, 'n_1_1_1_2')
n_1_1_1_2_1 = tree1.create_item(n_1_1_1_2, 'n_1_1_1_2_1')
tree1.create_item(n_1, 'n_1_2')
tree1.create_item(nil, 'n_2')

puts 'Все элементы скопом'
puts tree1.items.inspect

puts '-' * 60
puts 'Дерево элементов'
puts tree1.tree.inspect

puts '-' * 60
puts 'Узлы дерева'
puts tree1.tree_nodes.inspect

puts '-' * 60
puts 'Найти всех родителей элемента n_1_1_1_1'
n_1_1_1_1.ancestors.each {|i| puts tree1.items[i].name}

puts '-' * 60
puts 'Найти подчиненных элемента n_1_1_1 - один уровень'
tree1.tree_nodes[n_1_1_1.ref].keys.each {|i| puts tree1.items[i].name}

puts '-' * 60
puts 'Найти подчиненных элемента n_1_1_1 - все уровни'
tree1.items.select { |k,v| v.ancestors.include?(n_1_1_1.ref)}.to_a.each { |i| puts i[1].name }
