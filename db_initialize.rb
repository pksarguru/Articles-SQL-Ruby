# Run ruby code to initialize database values
# Serves as record of commands used to create existing databases
require "sqlite3"
require "faker"
  

# create SQLite3 database
db = SQLite3::Database.new("db_articles.db")

# create USER table
create_table_user = <<-SQL
  CREATE TABLE IF NOT EXISTS user(
    id INTEGER PRIMARY KEY,
    name VARCHAR(255)
  );
SQL

db.execute(create_table_user)

# create ARTICLE table
create_table_article = <<-SQL
  CREATE TABLE IF NOT EXISTS article(
    id INTEGER PRIMARY KEY,
    article_name VARCHAR(255),
    author_name VARCHAR(255),
    topic VARCHAR(255),
    url VARCHAR(255)
  );
SQL

db.execute(create_table_article)

# create REVIEW table
create_table_review = <<-SQL
  CREATE TABLE IF NOT EXISTS review(
    id INTEGER PRIMARY KEY,
    user_id INT,
    article_id INT,
    stars INT,
    comments VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (article_id) REFERENCES article(id)
  );
SQL

db.execute(create_table_review)

def find_user_id (db, user)
  user_values = db.execute("SELECT id FROM user where name = ?", [user])
end

def find_article_id (db, article)
  article_values = db.execute("SELECT id FROM article where article_name = ?", [article])
end

# Method to push values
def create_values(db, name, article, author, topic, url, stars, comments)
  db.execute("INSERT INTO user (name) VALUES (?)", [name])
  db.execute("INSERT INTO article (article_name, author_name, topic, url) VALUES (?, ?, ?, ?)", 
    [article, author, topic, url])
  db.execute("INSERT INTO review (user_id, article_id, stars, comments) VALUES (?, ?, ?, ?)",
    [find_user_id(db,name), find_article_id(db, article), stars, comments])
end


# Populates with random data
# 3.times do 
#   create_values(db, Faker::Name.name, Faker::Book.title, Faker::Book.author, Faker::Book.genre, 
#     Faker::Internet.url, 3, Faker::Hipster.sentence(4, false, 4))
# end


