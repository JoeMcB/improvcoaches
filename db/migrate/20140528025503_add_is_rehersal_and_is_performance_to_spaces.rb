class AddIsRehersalAndIsPerformanceToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :is_rehearsal, :boolean, default: true
    add_column :spaces, :is_performance, :boolean, default: false
  end
end
