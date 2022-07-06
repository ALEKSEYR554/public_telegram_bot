require "sqlite3"

# Open a database
@db = SQLite3::Database.new "channel.db"
def is_admin(code)
  code=code.to_s
  puts code
  @db.execute("select * from admin_list") do |a|
    puts a.typs
    return true if a[0].to_s==code end
  return false
end
puts 4.times.map { (0...(rand(10))).map { ('a'..'z').to_a[rand(26)] }.join }.join("")
