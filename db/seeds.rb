# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

class Seeder
  ORDER = [Admin, User, Post, FollowingUser]

  def run
    path = Rails.root.join("db", "seeds", "*.yml")
    files = Dir.glob(path)
    ordered_files = ORDER.map do |model|
      files.find { |file| File.basename(file, ".yml").classify == model.name }
    end.compact

    ordered_files.each do |file|
      model, attrs = load_seed_file(file)
      ActiveRecord::Base.connection.disable_referential_integrity do
        if model == User
          attrs = encrypt_password(attrs)
        end
        model.upsert_all(attrs)
      end
    end

    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end

  private

    def load_seed_file(file)
      attrs = YAML.safe_load_file(file)
      file_name = File.basename(file, ".yml")
      model = file_name.classify.constantize

      [model, attrs]
    end

    def encrypt_password(attrs)
      attrs.map do |attr|
        attr["encrypted_password"] = Devise::Encryptor.digest(User, attr["encrypted_password"])
        attr
      end
    end
end

Seeder.new.run
