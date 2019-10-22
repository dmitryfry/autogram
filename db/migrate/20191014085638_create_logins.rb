class CreateLogins < ActiveRecord::Migration[5.2]
  def change
    create_table :logins do |t|
      t.string :name
      t.boolean :following
      t.boolean :friend
      t.boolean :used

      t.timestamps
    end unless table_exists?(:logins)
  end
end
