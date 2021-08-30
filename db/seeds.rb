# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

token_length = ApplicationSetting.find_or_initialize_by(name: :token_length)
if token_length.new_record?
  token_length.value = 3
  token_length.save!
end