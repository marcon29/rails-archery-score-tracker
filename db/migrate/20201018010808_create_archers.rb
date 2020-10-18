class CreateArchers < ActiveRecord::Migration[6.0]
  def change
    create_table :archers do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :gender
      t.string :home_city
      t.string :home_state
      t.string :home_country
      t.string :default_age_class

      t.timestamps
    end
  end
end
