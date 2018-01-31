class CreateCommands < ActiveRecord::Migration[5.1]
  def self.up
    create_table :commands do |t|
      t.string  :user,           null: false
      t.string  :trackable_type, null: false
      t.integer :trackable_id,   null: false
      t.string  :line,         null: false

      t.timestamps
    end
    add_index :commands, [:trackable_id, :trackable_type]
    add_index :commands, :created_at
  end

  def self.down
    drop_table :commands
  end

end
