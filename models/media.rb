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
      [params[:mime_type], params[:file_name]]
    )

    return DB.last_insert_row_id
  end

  def self.upload(params)
    raise ArgumentError, "mime_type is required" unless params[:mime_type].is_a?(String)
    raise ArgumentError, "file_name is required" unless params[:file_name].is_a?(String)
    raise ArgumentError, "tempfile is required" unless params[:tempfile].respond_to?(:read)

    file_extension = params[:file_name].split(".").last

    file_id = self.insert({
      mime_type: params[:mime_type],
      file_name: "temporary",
    })

    file_name = "#{file_id}.#{file_extension}"
    file_path = File.join("public/uploads", file_name)

    File.open(file_path, "wb") { |file| file.write(params[:tempfile].read) }

    self.update(file_id, file_name: file_name)

    return file_id
  end

  def self.delete!(id)
    file = self.select_one(id: id)

    return if file.nil?

    file_name = file["file_name"]
    file_path = File.join("public/uploads", file_name)

    if File.exist?(file_path)
      File.delete(file_path)
    end

    super(id)
  end
end
