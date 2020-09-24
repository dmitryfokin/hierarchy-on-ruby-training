require 'securerandom'

class HierarchyItem
  attr_accessor :ref
  attr_accessor :name
  attr_accessor :level
  attr_accessor :ancestors

  def initialize options
    @ref = options[:ref] || SecureRandom.uuid
    @name = options[:name] || '-'
    @level = 0
    @ancestors = [] # массив предков, где индекс является уровнем иерархии

    if !options[:parent].nil?
      @level = options[:parent].level + 1
      @ancestors = options[:parent].ancestors.clone
      @ancestors << options[:parent].ref # добавляем самого родителя в предки
    end
  end

  def new_parent parent = nil
    if parent.nil?
      @level = 0
      @ancestors = []
    else
      @level = parent.level + 1
      @ancestors = parent.ancestors.clone
      @ancestors << parent.ref # добавляем самого родителя в предки
    end
  end
end
