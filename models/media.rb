require_relative "base_model"

class Media < BaseModel
  @table_name = "media"

  def self.create_table!
    DB.execute("
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mime_type TEXT NOT NULL,
        file_name TEXT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT current_timestamp
      )
    ")
  end

  def self.insert(params)
    DB.execute(
      "INSERT INTO media (mime_type, file_name) VALUES (?,?)",
      [ params[:mime_type], params[:file_name] ]
    )

    return DB.last_insert_row_id
  end

  def self.upload(params)
   file_id = self.insert({
      mime_type: params[:mime_type],
      file_name: params[:file_name],
    })

    file_path = "public/uploads/#{file_id}.#{params[:mime_type].split('/')[1]}"
    File.open(file_path, 'wb') {|file| file.write(params[:tempfile].read) }

    return file_id
  end
end
