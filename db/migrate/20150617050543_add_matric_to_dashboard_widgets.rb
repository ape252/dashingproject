class AddMatricToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :matric, :string
  end
end
