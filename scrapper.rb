require "nokogiri"
require_relative 'post'
require_relative 'user'
require_relative 'comment'


post = Post.new('https://news.ycombinator.com/item?id=7663775')







p post.comments[0].comment
p post.comments[0].user.name
p post.comments[0].age
p post.points
p post.title.nil?
p post.title
p post.item_id


