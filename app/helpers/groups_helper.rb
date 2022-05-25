module GroupsHelper
  attr_reader :groups_new
  def make_tree_children_view(groups, root_id)
    root_group = find_root_group(groups, root_id)
    tree = Node.new(**root_group)
    @groups_new = groups.reject { |group| group.id == root_id }

    recursive(tree)

    tree
  end

  def find_root_group(groups, root_id)
    groups.reject { |group| group.id != root_id }.first.attributes
  end

  def recursive(node)
    children = groups_new.select{ |group| group.parent_id == node.id }
    children.map do |ch|
      child_node = Node.new(**ch.attributes)
      node.add_child(child_node)
      recursive(child_node)
    end
  end
end


