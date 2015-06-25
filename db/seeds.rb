# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_users
  User.destroy_all
  User.create(name: 'Sid', 
              email: 'no_reply@linkastor.herokuapp.com',
              avatar: 'http://images2.fanpop.com/images/polls/308000/308926_1254839318372_full.jpg',
              nickname: 'sid')
end

def seed_groups
  Group.destroy_all
  group = Group.create(name: 'Seed group')
  GroupsUser.create(user: User.first, group: group)
end

def seed_custom_sources
  CustomSource.destroy_all
  twitter = CustomSources::Twitter.create(name: "Twitter", extra: {username: "mattgemmell"})
  CustomSourcesUser.create(user: User.first, custom_source: twitter)
end

def seed_links
  Link.destroy_all
  for i in 0..10 do
    Link.create(title: 'Seeded link', 
                        url: 'http://www.google.com', 
                        group: Group.first, 
                        posted_by: User.first,
                        created_at: i.days.ago,
                        updated_at: i.days.ago)
  end
  
  for i in 0..2 do
    Link.create(title: 'Another Seeded link',
                url: 'http://www.google.com',
                custom_source: CustomSource.first, 
                created_at: i.days.ago,
                updated_at: i.days.ago)
  end
end

if Rails.env != 'test'
  seed_users
  seed_groups
  seed_custom_sources
  seed_links
end