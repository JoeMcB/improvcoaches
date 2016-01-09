class AddIsImprovAndIsSketchToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_sketch, :boolean
  	add_column :users, :is_improv, :boolean

  end

  def migrate(direction)
  	super 
  	
  	if direction == :up
	  User.coaches.each do |c|
	  	c.is_improv = true
	  	c.is_sketch = false
	  	c.save
	  end
	end
  end
end
