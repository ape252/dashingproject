class RenameColumnName < ActiveRecord::Migration
  def change
  	rename_column :dashboard_widgets, :name, :sonar_server
  end
end
