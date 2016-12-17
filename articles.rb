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
#       view all saved articles with all info
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
# 
# Methods:
#   ADD USER
#     Input: name
#     Steps: 
#       run SQL command to add new user
#     output: new user in database
#   ADD ARTICLE
#     Input: name, article_name, author_name, topic, url, stars, comments
#     Steps:
#       run SQL command to add new article with attributes
#     Output: new article in database
#   DELETE ARTICLE
#     Input: name, article_name
#     Steps:
#       run SQL command to delete article by name
#     Output: article removed from database
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