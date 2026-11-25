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


    before do
      @categories = categories
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
      erb(:'todos/show')

    end

    get "/todos/:id/edit" do |id|
      @todo = todo(id)
      erb(:'todos/edit')
    end

    post "/todos" do
      name = params["name"]
      description = params["description"]
      cat_id = params["category"]

      db.execute("INSERT INTO todos (name, description, category_id, completed) 
                  VALUES (?, ?, ?, ?)", [name, description, cat_id, 0])

      redirect("/")
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

    post "/todos/:id/update" do |id|
      name = params["name"]
      description = params["description"]
      cat_id = params["category"]

      db.execute("UPDATE todos SET name=?, description=?, category_id=? WHERE id=?", [name, description, cat_id, id])
      redirect("/")
    end

end
