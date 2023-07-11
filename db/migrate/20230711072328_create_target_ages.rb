class CreateTargetAges < ActiveRecord::Migration[6.1]
  def change
    create_table :target_ages do |t|

      t.string :age, null: false, default: 0
      
      t.timestamps
    end
  end
end
