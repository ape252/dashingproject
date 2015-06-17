class AddKeyToDashboardWidgets < ActiveRecord::Migration
  def change
    add_column :dashboard_widgets, :key, :string
  end
end
