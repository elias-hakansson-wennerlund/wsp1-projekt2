require_relative "../db/db.rb"

class BaseModel
  def self.drop_table!
    DB.execute("DROP TABLE IF EXISTS #{@table_name}")
  end

  def self.create_table!
    raise NotImplementedError, "Define in a subclass"
  end

  def self.insert(params)
    raise NotImplementedError, "Define in a subclass"
  end

  def self.select_one(params)
    self.select_many(params, 1).first
  end

  def self.select_many(params = {}, limit = nil)
    query_parts = []
    values = []

    params.each do |key, value|
      next if value.nil?

      query_parts << "#{key} = ?"
      values << value
    end

    where_clause = query_parts.empty? ? "" : "WHERE #{query_parts.join(" AND ")}"
    limit_clause = limit ? "LIMIT #{limit}" : ""

    query = "SELECT * FROM #{@table_name} #{where_clause} #{limit_clause}"

    DB.execute(query, values)
  end

  def self.update(id, params)
    query_parts = []
    values = []

    params.each do |key, value|
      next if value.nil?

      query_parts << "#{key} = ?"
      values << value
    end

    raise ArgumentError, "No valid parameters to update" if query_parts.empty?

    query = "UPDATE #{@table_name} SET #{query_parts.join(", ")} WHERE id = ?"
    values << id

    DB.execute(query, values)
  end

  def self.delete!(id)
    DB.execute("DELETE FROM #{@table_name} WHERE id = ?", [id])
  end
end
