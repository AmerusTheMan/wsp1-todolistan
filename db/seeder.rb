require 'sqlite3'
require_relative '../config'

db = SQLite3::Database.new(DB_PATH)

puts "Använder databasen: #{DB_PATH}"
puts "🧹 Tar bort gamla tabeller..."
db.execute('DROP TABLE IF EXISTS todos')
db.execute('DROP TABLE IF EXISTS categories')

puts "🧱 Skapar tabeller..."
db.execute('CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, 
            description TEXT,
            completed INTEGER DEFAULT 0,
            category_id INTEGER )')

db.execute('CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, 
            description TEXT  )')


puts "🍎 Fyller på med data..."
db.execute('INSERT INTO todos (name, description, completed, category_id) VALUES ("Köp mjölk", "3 lite mellanmjölk, eko", 1, 2)')
db.execute('INSERT INTO todos (name, description, completed, category_id) VALUES ("Köp julgran", "En rödgran", 0, 2)')
db.execute('INSERT INTO todos (name, description, completed, category_id) VALUES ("Pynta gran", "Glöm inte lamporna i granen och tomten", 0, 3)')

db.execute('INSERT INTO categories (name, description) VALUES ("privat", "saker som bara jag ser")')
db.execute('INSERT INTO categories (name, description) VALUES ("inköp", "saker som ska köpas in")')
db.execute('INSERT INTO categories (name, description) VALUES ("jul", "saker som hör till julen")')

puts "✅ Databasen är seedad!"