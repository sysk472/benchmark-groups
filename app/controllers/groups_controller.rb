require 'benchmark'
class GroupsController < ApplicationController
  respond_to :json
  #-----------------------------------------------------------------------------
  # GET index /groups?rootGroup
  #-----------------------------------------------------------------------------
  def index
    # Benchmark.benchmark("Processing groups...") do
      if query_param.include?(:group_id)
        respond_with(index_cache_query)
      else
        respond_with(index_cache)
      end
    # end
  end

  #-----------------------------------------------------------------------------
  # GET show /group_tree/:group_id
  #-----------------------------------------------------------------------------
  def show
    # Benchmark.benchmark("Processing group %...") do
      respond_with(show_cache)
    # end
  end

  #-----------------------------------------------------------------------------
  # GET change_root_structure /change_root_structure/:group_id
  #-----------------------------------------------------------------------------
  def change_root_structure
    root = Group.find_by(id: 2501)
    root.update(name: "Group 2501 Changed #{Time.now}")

    redirect_to group_tree_path(group_id: root.id)
  end
  

  private

  def query_param
    params.permit(:group_id, :format)
  end

  def index_cache_query
    Rails.cache.fetch([self.class.name, __method__, params[:group_id]]) do
      Group.find(params[:group_id]).children
    end
  end
  
  def index_cache
    Rails.cache.fetch([self.class.name, __method__, params[:group_id]]) do
      Group.where(parent_id: nil)
    end
  end

  def show_cache
    group = Group.find(params[:group_id])
    Rails.cache.fetch([self.class.name, __method__, params[:group_id], group.cache_version]) do
      helpers.make_tree_children_view(Group.find(params[:group_id]).all_children_sql, params[:group_id].to_i)
    end
  end
end
