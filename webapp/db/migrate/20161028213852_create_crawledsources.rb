class CreateCrawledsources < ActiveRecord::Migration
  def change
    create_table :crawledsources do |t|
      t.string :uid
      t.string :name
      t.datetime :updated_at,    null: false
    end
  end
end
