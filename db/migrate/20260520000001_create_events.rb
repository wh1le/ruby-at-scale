# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :event_type
      t.decimal :amount, precision: 10, scale: 2
      t.timestamps
    end
  end
end
