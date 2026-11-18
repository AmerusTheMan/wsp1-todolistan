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
      ", id).first
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

    ###########
    ## INDEX ##
    ###########
    get "/" do        
      @todos = todos

      erb(:'todos/index')
    end

    ##########
    ## TODO ##
    ##########
    get "/todos/:id" do |id|
      @todo = todo(id)
      ap @todo
      ap @todo["name"]
      erb(:'todos/show')

    end

    post "/todos/:id/set_completed" do |id|
      db.execute("UPDATE todos SET completed=1 WHERE id=?", [id])
      redirect("/")
    end

    post "/todos/:id/set_not_completed" do |id|
      db.execute("UPDATE todos SET completed=0 WHERE id=?", [id])
      redirect("/")
    end
    
    post "/todos/:id/delete" do |id|
      db.execute("DELETE FROM todos WHERE id=?", [id])
      redirect("/")
    end

end
