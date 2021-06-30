class SorceryCore < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email,            null: false
      t.string :crypted_password
      t.string :salt
      t.string :nickname, null: false
      t.text :description
      t.boolean :anonymous, default: false, null: false

      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
  end
end