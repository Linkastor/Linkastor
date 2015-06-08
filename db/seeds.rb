# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

group = Group.where(name: 'Seed group').first_or_create
user = User.find(1)
user.groups << group

for i in 0..100 do
	link = Link.create(title: 'Seeded link', url: 'http://www.google.com', group: group, posted_by: user.id)
	link.update_attribute :created_at, i.day.ago
	link.update_attribute :updated_at, i.day.ago
end