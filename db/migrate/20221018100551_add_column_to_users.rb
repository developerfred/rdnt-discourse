# frozen_string_literal: true

class AddColumnToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :lock_timestamp, :timestamp
  end
end
