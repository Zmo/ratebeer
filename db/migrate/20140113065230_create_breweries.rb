class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries do |t|
      t.string :name
      t.integer :year
      t.boolean :active
    end
  end
end
