namespace :dev do
  task fake_user: :environment do
    admin = User.where(role_id:"1")
    User.destroy_all unless admin
    20.times do |i|
      name = FFaker::Name.first_name
      user = User.new(
        name: name,
        email: "#{name}@example.co",
        password: "12345678",
        intro: FFaker::Lorem::sentence(30)
      )
      user.save!
      puts user.name
    end
    puts "now you have #{User.count} user data"
  end

  task fake_topic: :environment do
    Topic.destroy_all
    50.times do |i|
      Topic.create!(
        title: FFaker::Lorem::phrase,
        content: FFaker::Lorem.sentence,
        user: User.all.sample
      )
      TopicCategoryship.create!(
        topic_id: Topic.last.id,
        category_id: Category.all.sample.id
      )
    end
    puts "now you have #{Topic.count} topic data"
  end

  task fake_comment: :environment do
    Topic.all.each do |topic|
      3.times do |i|
        topic.comments.create!(
          content: FFaker::Lorem.sentence,
          user: User.all.sample
        )
      comment_last = Comment.last
      topic.update(last_commnet_created_at: comment_last.created_at)
      end
    end
    puts "now you have #{Comment.count} comment data"
  end
  
  task setup: [
    "db:setup",
    :fake_user,
    :fake_topic,
    :fake_comment
  ]

  task fake_all: [
    :fake_user,
    :fake_topic,
    :fake_comment
  ]

end
