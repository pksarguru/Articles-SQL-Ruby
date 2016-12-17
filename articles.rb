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
    [find_user_id(db,name), find_article_id(db,article), stars, comments]) 
end 

#   DELETE ARTICLE
#     Input: name, article_name
#     Steps:
#       run SQL command to delete article by name
#     Output: article removed from database
def delete_article(db, name, article_name)
  db.execute("DELETE FROM article WHERE article_name=(?) and user_id = (?)",
    [article_name, find_user_id(db, name)])
end
#   CHANGE REVIEW OF ARTICLE
#     Input: name, article_name, stars, comments
#     Steps:
#       run SQL command to change stars and comments for a given article for a given user
#     Output: updated reviews database
#   VIEW ALL ARTICLES
#     Input: name
#     Steps:
#       Run SQL command to display all articles for given user
#     Output: all article info for given user
#   LAUNCHY
#     Input: article URL
#     Steps:
#       Run Launchy command to open url
#     Output: opened website in separate window


# Driver Code

article_data = db.execute("SELECT * FROM article")
review_data = db. execute("SELECT * FROM review")

# Test Adding user
add_user(db, "Pavan")

p db.execute("SELECT * FROM user")

