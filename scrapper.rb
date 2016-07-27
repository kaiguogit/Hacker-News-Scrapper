require "nokogiri"
require_relative 'post'
require_relative 'user'
require_relative 'comment'
require 'open-uri'
require 'colorize'


def print_comment(comment)
  puts ""
  puts "By user: #{comment.user.name}".red.on_white
  puts "#{comment.age}".blue.on_white
  puts "#{comment.comment}".green
end

def hit_enter
  puts "\nPlease hit enter for more"
  loop do
    break if STDIN.gets == "\n" 
    puts "Invalid input, please hit enter"
  end 
end

if ARGV.length >= 1
  post = Post.new(ARGV[0])
  puts "Post title: #{post.title}".red.bold.on_white
  puts "Number of comments: #{post.comments.length}".yellow.bold
  puts "Points: #{post.points}".blue.bold
  puts "item_id: #{post.item_id}".magenta.bold
  case ARGV[1]
  when "comments"
    post.comments.each_with_index do |comment, index|
      print_comment(comment)
      hit_enter if index % 5 == 4
    end
  else
  end
else
  puts "Invalid number of arguments"
  puts "Usage: ruby scrapper.rb https://news.ycombinator.com/item?id=7663775"
end

