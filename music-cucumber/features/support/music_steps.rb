require 'faker'

Given /^a user exists$/ do
  user = Music::User.create(
    :name => 'Test User',
    :username => 'testuser',
    :bbcid => 12345)
  @user_id = user.username
end

Given /^an? (disabled|active|inactive)? ?music guide called "([^\"]*)" exists$/ do |status,name|
  status = case status
    when 'disabled' then 0
    when 'active' then 1
    when 'inactive' then 2
    else 1
  end
  user = Music::User.create(
    :name => name,
    :username => name.downcase.gsub(/\W/, ''),
    :status => status,
    :is_guide => 1,
    :bbcid => 2345)
  @user_id = user.username
end

Given /^(\d+) music guides exist$/ do |i|
  i.to_i.times do
    Music::User.create(
      :name => Faker::Name.name,
      :bbcid => rand(10000).to_i,
      :is_guide => 1,
      :username => Faker::Internet.user_name.gsub(/\W+/, ''),
      :shortSynopsis => Faker::Lorem.paragraph(1),
      :mediumSynopsis => Faker::Lorem.paragraphs(3).join)
  end
end

Given /^(\d+) featured music guides exist$/ do |i|
  i.to_i.times do |i|
    Music::User.create(
      :name => Faker::Name.name,
      :bbcid => rand(10000).to_i,
      :status => 1,
      :is_guide => 1,
      :featured_position => i,
      :username => Faker::Internet.user_name.gsub(/\W+/, ''),
      :shortSynopsis => Faker::Lorem.paragraph(1),
      :mediumSynopsis => Faker::Lorem.paragraphs(3).join)
  end
end

Given /^a playlist exists$/ do
  playlist = Music::Playlist.create(
    :url_key => 'abcd',
    :title => 'Test Playlist',
    :short_synopsis => 'A short playlist synopsis',
    :medium_synopsis => 'A medium playlist synopsis')
  @playlist_id = playlist.url_key
end

Given /^a track exists$/ do
  playlist = Music::Playlist.all.last
  track = Music::Track.create(
    :playlist => playlist,
    :track => {
      :title => 'Track title',
      :artist_name => 'Test artist',
      :artist_gid => '7e84f845-ac16-41fe-9ff8-df12eb32af55'
    })
  @track_id = track.id
end

Given /^a collection exists$/ do
  collection = Music::Collection.create(
    :title => 'Test Collection',
    :short_synopsis => 'A short collection synopsis',
    :medium_synopsis => 'A medium collection synopsis')
  @collection_id = collection.url_key
end

Given /^a clip exists$/ do
  collection = Music::Collection.all.last
  clip = Music::Clip.create(
    :pid => 'abcd',
    :title => 'Test Clip',
	:collection => collection)
  @clip_pid = clip.pid
end

Given /^all users have some content$/ do
  users = Music::User.all.inject({}){ |h,u| h[u.username] ||= u; h }.values
  users.each do |user|
    Music::Playlist.create(
      :user => user, 
      :title => Faker::Lorem.sentence)
  end
end

Then /^there should be (\d+) collections/ do |count|
  Music::Collection.all.size.should == count.to_i
end

Then /^there should be (\d+) clips?/ do |count|
  Music::Collection.all.inject(0) { |count, collection| count += collection.clips.size }.should == count.to_i
end
