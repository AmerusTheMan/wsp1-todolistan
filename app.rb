require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
        return @db if @db

        @db = SQLite3::Database.new(DB_PATH)
        @db.results_as_hash = true

        return @db
    end

    def todos
        db.execute("
            SELECT todos.*, categories.name AS cat_name FROM todos
            LEFT JOIN categories
            ON categories.id = todos.category_id
        ")
    end

    def todo(id)
      db.execute("
        SELECT todos.*, categories.name AS cat_name FROM todos
        LEFT JOIN categories
        ON categories.id = todos.category_id
        WHERE todos.id=?
      ", id)
    end

    def todos_on_category(cat_id)
      db.execute("
        SELECT todos.*, categories.name AS cat_name FROM todos
        LEFT JOIN categories
        ON categories.id = todos.category_id
        WHERE categories.id=?
      ", cat_id)
    end

    def categories
      db.execute("
        SELECT * FROM categories
      ")
    end

    def category(id)
      db.execute("
        SELECT * FROM categories
        WHERE id=?
      ", id)
    end



    get '/' do        
        @todos = todos_on_category(2)
        erb(:'todos/index')
    end

end
