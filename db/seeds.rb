# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_users
  User.destroy_all
  User.create!(name: 'Sid', 
              email: 'no_reply@linkastor.herokuapp.com',
              avatar: 'http://images2.fanpop.com/images/polls/308000/308926_1254839318372_full.jpg',
              nickname: 'sid')
end

def seed_groups
  Group.destroy_all
  group = Group.create!(name: 'Seed group')
  GroupsUser.create!(user: User.first, group: group)
end

def seed_custom_sources
  CustomSource.destroy_all
  twitter = CustomSources::Twitter.create!(name: "Twitter", extra: {username: "mattgemmell"})
  CustomSourcesUser.create!(user: User.first, custom_source: twitter)
end

def seed_links
  Link.destroy_all
  (0..10).each do |i|
    Link.create!(title: 'Seeded link', 
                        url: "http://www.google.com/#{i}", 
                        group: Group.first, 
                        image_url: "https://tctechcrunch2011.files.wordpress.com/2014/02/shutterstock_173525351.jpg?w=560&h=292&crop=1",
                        description: "Most people didn’t notice last month when a 35-person company in San Francisco called HoneyBook announced a $22 million Series B. What was unusual about the..",
                        posted_by: User.first.to_param,
                        created_at: i.days.ago,
                        updated_at: i.days.ago)
  end
  
  (0..2).each do |i|
    Link.create!(title: 'Another Seeded link',
                url: "http://www.producthunt.com/#{i}",
                custom_source: CustomSource.first, 
                image_url: "https://tctechcrunch2011.files.wordpress.com/2014/02/shutterstock_173525351.jpg?w=560&h=292&crop=1",
                description: "Most people didn’t notice last month when a 35-person company in San Francisco called HoneyBook announced a $22 million Series B. What was unusual about the..",
                created_at: i.days.ago,
                updated_at: i.days.ago)
  end

  Link.create!(title: 'link with no description', 
                url: "http://youboox.com", 
                group: Group.first,
                image_url: "http://fr.cdn.v5.futura-sciences.com/builds/images/thumbs/7/782e449ea7_biere-bulles_wakala-deviantart.com-cc-by-30.jpg", 
                posted_by: User.first.to_param,
                created_at: 0.days.ago,
                updated_at: 0.days.ago)

  Link.create!(title: 'link with no image_url', 
                url: "http://octo.com", 
                group: Group.first,
                description: "This is my simple description",
                posted_by: User.first.to_param,
                created_at: 0.days.ago,
                updated_at: 0.days.ago)

  Link.create!(title: 'link with no meta', 
                url: "http://techcrunch.com/2015/06/30/apple-music-and-ios-8-4-now-available/", 
                group: Group.first, 
                posted_by: User.first.to_param,
                created_at: 0.days.ago,
                updated_at: 0.days.ago)
end

if Rails.env != 'test'
  seed_users
  seed_groups
  seed_custom_sources
  seed_links
end