class AddActivityToBrewery < ActiveRecord::Migration
  def change
    add_column :breweries, :active, :booolean
  end
end
