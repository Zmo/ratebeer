class DeleteBreweries < ActiveRecord::Migration
  def change
    drop_table :breweries
  end
end
