# Favorite Article storage
# 
#   Features for user:
#     store articles
#       name 
#       author
#       url
#       topic
#       rating
#       comment
#      view all saved articles with all info
# 
#   Stretch Features:
#     go straight to articles from terminal
#       => Ruby gem - Launchy
#     share articles with others
#       => send to other user database
# 
#   Database Structure: => create tables and columns in database
#     USER
#       name
#     REVIEW
#       user_id
#       article_id
#       stars
#       comments
#     ARTICLE
#       article_name
#       author_name
#       topic
#       url


require "sqlite3"
require "faker"
require_relative "db_initialize"

db = SQLite3::Database.open("db_articles.db")

#ID Methods from initialization file
def find_user_id (db, user)
  user_values = db.execute("SELECT id FROM user WHERE name = ?", [user])
  user_values[0][0]
end

def find_article_id (db, article)
  article_values = db.execute("SELECT id FROM article WHERE article_name = ?", [article])
  article_values[0][0]
end

def find_article_id_from_user_id (db, user_id)
  article_id = db.execute("SELECT article_id FROM review WHERE user_id = ?", [user_id])
  if article_id == []
    puts "Sorry nothing here yet"
  else
    article_id
  end
end

# Methods:
#   ADD USER
#     Input: name
#     Steps: 
#       run SQL command to add new user
#     output: new user in database
def check_user(db, name)
  name_check = db.execute("SELECT name FROM user WHERE name=(?)", [name])
  if name_check[0] != nil
    true
  else
    false
  end
end

def add_user(db, name)
  if !check_user(db,name)
    db.execute("INSERT INTO user (name) VALUES (?)", [name])
  end
end



#   ADD ARTICLE
#     Input: name, article_name, author_name, topic, url, stars, comments
#     Steps:
#       run SQL command to add new article with attributes
#     Output: new article in database
def check_article(db, article_name)
  article_check = db.execute("SELECT article_name FROM article WHERE article_name=(?)", [article_name])
  p article_check
  article_check = article_check[0]
  if article_check == article_name
    true
  else
    false
  end
end

def add_article(db, name, article_name, author_name, topic, url, stars, comments)
  if !check_article(db, article_name)
    db.execute("INSERT INTO article (article_name, author_name, topic, url) VALUES (?, ?, ?, ?)",
      [article_name, author_name, topic, url])
    db.execute("INSERT INTO review (user_id, article_id, stars, comments) VALUES (?, ?, ?, ?)",
      [find_user_id(db,name), find_article_id(db,article_name), stars, comments]) 
  end
end 

#   DELETE ARTICLE
#     Input: name, article_name
#     Steps:
#       run SQL command to delete article by name
#     Output: article removed from database
def delete_article(db, name, article_name) #=> deletes review from user but does not delete article entirely
  db.execute("DELETE FROM review WHERE article_id=(?) AND user_id = (?)",
    [find_article_id(db, article_name), find_user_id(db, name)])
end
#   CHANGE REVIEW OF ARTICLE
#     Input: name, article_name, stars, comments
#     Steps:
#       run SQL command to change stars and comments for a given article for a given user
#     Output: updated reviews database
def change_review (db, name, article_name, stars, comments)
  db.execute("UPDATE review SET stars=(?), comments=(?) WHERE article_id =(?) AND user_id = (?)",
    [stars, comments, find_article_id(db, article_name), find_user_id(db, name)])
end
# 
#   VIEW ALL ARTICLES
#     Input: name
#     Steps:
#       Run SQL command to display all articles for given user
#     Output: all article info for given user
def get_article_array (db, user)
  user_id = find_user_id(db, user)
  article_id = find_article_id_from_user_id(db, user_id)
  article_array = []
  if article_id != nil 
    article_id.each do |item|
      item_array = db.execute("SELECT article.article_name, article.author_name, article.topic, article.url, review.stars, review.comments FROM article INNER JOIN review ON article.id = review.article_id WHERE article.id = ?", [item[0]])
      article_array << item_array
    end
  end

  # article_array = article_array[0]
  article_array
end

def print_article(user, arr)
  if !arr.empty? 
    print user + "'s Articles:"
    puts
    arr.each do |article| 
      article.each do |article_element|
        puts "--------------------"

        puts "Name: " + article_element[0]
        puts "Author: " + article_element[1]
        puts "Website: " + article_element[2]
        puts "URL: " + article_element[3]
        puts "Stars: " + article_element[4].to_s
        puts "Comments: " + article_element[5]
      end
    end
  end
end


#   LAUNCHY
#     Input: article URL
#     Steps:
#       Run Launchy command to open url
#     Output: opened website in separate window


# DRIVER CODE/TEST CODE
# __________________________

# Test Adding user
# add_user(db, "Pavan")

# p db.execute("SELECT * FROM user")

# Testing add article
# add_article(db, "Pavan", "A Buddhist monk explains mindfulness for times of conflict", "Eliza Barclay",
#    "Health", "http://www.vox.com/science-and-health/2016/11/22/13638374/buddhist-monk-mindfulness",
#    4, "Great Article about training your mind!")

# p db.execute("SELECT * FROM article")

# p db.execute("SELECT * FROM review")
# Testing delete article
  # delete_article(db, "Pavan", "A Buddhist monk explains mindfulness for times of conflict")

  # p db.execute("SELECT * FROM article")

  # p db.execute("SELECT * FROM review")  

# Testing change review

  # p db.execute("SELECT * FROM review WHERE article_id = ?", [find_article_id(db, "A Buddhist monk explains mindfulness for times of conflict")]) 

  # change_review(db, "Pavan", "A Buddhist monk explains mindfulness for times of conflict", 5, "Even better than I thought!")

  # p db.execute("SELECT * FROM review WHERE article_id = ?", [find_article_id(db, "A Buddhist monk explains mindfulness for times of conflict")]) 

# Testing printing article array

# article_array = get_article_array(db, "Pavan")
# # p article_array

# print_article("Pavan",article_array)

# USER INTERFACE
# __________________________

puts "Welcome to Ruby-SQL Article storage service."
puts "What's your name?"
user_name = gets.chomp

add_user(db, user_name)
user_input = ""

until user_input == "4"

  puts "What would you like to do?"
  puts "(Type the corresponding number)"
  puts "-------------------------------"
  puts "1. Add article"
  puts "2. View stored articles"
  puts "3. Delete article"
  puts "4. Quit"

  user_input = gets.chomp

  puts "-------------------------------"
  puts 

  if user_input == "1"
    puts "What's the name of the article you'd like to add?"
    user_article_name = gets.chomp
    puts "Who wrote the article?"
    user_article_author = gets.chomp
    puts "What website is it from?"
    user_article_website = gets.chomp
    puts "What's the URL?"
    user_article_url = gets.chomp
    puts "How many stars would you rate it (1-5)?"
    user_stars = gets.chomp
    puts "Do you have a short review or comment?"
    user_comment = gets.chomp

    add_article(db, user_name, user_article_name, user_article_author, user_article_website, user_article_url, user_stars, user_comment)

    system "clear"

    puts "Thanks for all the input"
  elsif user_input == "2"

    system "clear"

    puts
    print_article(user_name,get_article_array(db, user_name))
    puts
  elsif user_input == "3"
    print_article(user_name,get_article_array(db, user_name))
    puts
    puts "Enter the name of the article you'd like to delete"
    user_article_delete = gets.chomp

    delete_article(db, user_name, user_article_delete)

    system "clear"
  elsif user_input == "4"
    break
  else 
    puts "Please enter valid input"
    user_input = gets.chomp
  end  

end

puts "Thanks for using the Ruby-SQL storage service."









