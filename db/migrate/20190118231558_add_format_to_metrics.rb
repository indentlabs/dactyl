class AddFormatToMetrics < ActiveRecord::Migration[5.2]
  def change
    add_column :metrics, :format_style, :string
  end
end
