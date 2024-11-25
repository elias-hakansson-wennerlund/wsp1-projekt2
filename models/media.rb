require_relative "base_model"

class Media < BaseModel
  @table_name = "media"

  def self.create_table!
    DB.execute("
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        file_type TEXT NOT NULL,
        file_name TEXT NOT NULL,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        created_at DATETIME NOT NULL DEFAULT current_timestamp
      );
    ")
  end

  def self.insert(params)
    DB.execute(
      "INSERT INTO media (url, file_type, file_name, width, height) VALUES (?,?,?,?,?)",
      [ params[:url], params[:file_type], params[:file_name], params[:width], params[:height] ]
    )
  end
end
