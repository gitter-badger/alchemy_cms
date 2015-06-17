class AddElementIdToAlchemyElements < ActiveRecord::Migration
  def change
    add_column :alchemy_elements, :element_id, :integer
    add_index :alchemy_elements, :element_id
  end
end
