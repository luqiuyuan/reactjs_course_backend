class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :content
      t.belongs_to :question
      t.belongs_to :user

      t.timestamps
    end
  end
end
