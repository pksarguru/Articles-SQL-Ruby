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
  article_id[0][0]
end

# Methods:
#   ADD USER
#     Input: name
#     Steps: 
#       run SQL command to add new user
#     output: new user in database
def add_user(db, name)
  db.execute("INSERT INTO user (name) VALUES (?)", [name])
end

#   ADD ARTICLE
#     Input: name, article_name, author_name, topic, url, stars, comments
#     Steps:
#       run SQL command to add new article with attributes
#     Output: new article in database

def add_article(db, name, article_name, author_name, topic, url, stars, comments)
  db.execute("INSERT INTO article (article_name, author_name, topic, url) VALUES (?, ?, ?, ?)",
    [article_name, author_name, topic, url])
  db.execute("INSERT INTO review (user_id, article_id, stars, comments) VALUES (?, ?, ?, ?)",
    [find_user_id(db,name), find_article_id(db,article_name), stars, comments]) 
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

#   CHECK IF ARTICLE EXISTS IN DATABASE
# 
#   VIEW ALL ARTICLES
#     Input: name
#     Steps:
#       Run SQL command to display all articles for given user
#     Output: all article info for given user
def get_article_array (db, user)
  user_id = find_user_id(db, user)
  article_id = find_article_id_from_user_id(db, user_id)

  article_array = db.execute("SELECT article.article_name, article.author_name, article.topic, article.url, review.stars, review.comments 
    FROM article 
    INNER JOIN review
    ON article.id = review.article_id
    WHERE article.id = ?", [article_id])

  # article_array = article_array[0]
  article_array
end

def print_article(user, arr)
  print user + "'s Articles:"
  puts
  arr.each do |article|
    puts "--------------------"

    puts "Name: " + article[0]
    puts "Author: " + article[1]
    puts "Website: " + article[2]
    puts "URL: " + article[3]
    puts "Stars: " + article[4].to_s
    puts "Comments: " + article[5]
  end
end


#   LAUNCHY
#     Input: article URL
#     Steps:
#       Run Launchy command to open url
#     Output: opened website in separate window


# Driver Code

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

article_array = get_article_array(db, "Pavan")
# p article_array

print_article("Pavan",article_array)

