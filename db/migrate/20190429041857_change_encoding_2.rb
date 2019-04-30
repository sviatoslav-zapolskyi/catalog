class ChangeEncoding2 < ActiveRecord::Migration[5.0]
  def change
    config = Rails.configuration.database_configuration
    db_name = config[Rails.env]["database"]
    collate = 'utf8_general_ci'
    char_set = 'utf8'

    execute("ALTER DATABASE #{db_name} CHARACTER SET #{char_set} COLLATE #{collate};")

    ActiveRecord::Base.connection.tables.each do |table|
      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
    end
  end
end
