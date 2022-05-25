class Node
  attr_accessor :id, :parent_id, :children, :name, :lvl
  
  def initialize(**params)
    params.symbolize_keys!
    @id = params[:id]
    @parent_id = params[:parent_id]
    @name = params[:name]
    @lvl = params[:lvl]
    @children = params[:children] || []
  end

  def add_child(child)
    children.push(child)
  end
end