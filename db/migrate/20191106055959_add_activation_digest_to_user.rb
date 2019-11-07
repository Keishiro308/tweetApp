class AddActivationDigestToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_digest, :string
  end
end
