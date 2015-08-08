class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :follower, index: true
      t.references :followed, index: true

      t.timestamps
      t.index :relationships, :follower_id
      t.index :relationships, :followed_id
      t.index [:follower_id, :followed_id], unique: true # この行を追加
    end
  end
end
