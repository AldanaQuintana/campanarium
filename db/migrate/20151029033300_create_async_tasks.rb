class CreateAsyncTasks < ActiveRecord::Migration
  def change
    create_table :async_tasks do |t|
      t.string :name
      t.string :status
      t.text :result_text
    end
  end
end
