class Group < ApplicationRecord
  belongs_to :parent, class_name: "Group", foreign_key: "parent_id", optional: true#, touch: true
  has_many :children, class_name: "Group", foreign_key: "parent_id"
  
  def all_children_sql
    Group.find_by_sql(recursive_tree_children_sql)
  end

  def recursive_tree_children_sql
    columns = self.class.column_names
    columns_joined = columns.join(', ')

    sql =
      <<-SQL
      WITH RECURSIVE group_tree (#{columns_joined})
      AS (
        SELECT
          #{columns_joined}
        FROM groups
        WHERE id = #{id}
      
      UNION ALL
        SELECT
          gr.id,
          gr.parent_id,
          gt.lvl + 1,
          gr.name,
          gr.created_at,
          gr.updated_at
        FROM groups gr, group_tree gt
        WHERE gr.parent_id = gt.id
      )
      SELECT * FROM group_tree
      WHERE lvl BETWEEN #{self.lvl} :: int4 AND 10
      ORDER BY lvl;
      SQL
    sql.chomp
  end

  # def to_node
  #   { 
  #     "attributes" => self.attributes,
  #     "children"   => self.children.map { |c| c.to_node }
  #   }
  # end
end