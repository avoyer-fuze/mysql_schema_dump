require 'mysql2'
require 'fileutils'
require 'yaml'

# Remove the folder since we'll re-create it
FileUtils.rm_rf("./servers/")

# Read yml file with databases
backup_dbs = YAML.load_file('databases.yml')

backup_dbs.each do |db, db_info|
  puts "Connecting to #{db}"
  schemas = db_info["schemas"]

  client = Mysql2::Client.new(
    host: db_info["ip"], 
    username: "t_infra",
    password: "15qpjDF01196"
  )

  schemas.each do |schema|
    # Get all Tables
    default_path = "./servers/#{db}/#{schema}"
    FileUtils.mkdir_p "#{default_path}/tables"

    results = client.query("select table_name from information_schema.tables where TABLE_SCHEMA = '#{schema}';")
    results.each do |row|
      info = client.query("show create table #{schema}.#{row['table_name']};")
      info.each do |info_result|
        File.open("#{default_path}/tables/#{row['table_name']}.sql", "w") {|f| f.write(info_result["Create Table"]) }
      end
    end

    # Get all Views
    FileUtils.mkdir_p "#{default_path}/views"

    results = client.query("select table_name from information_schema.views where TABLE_SCHEMA = '#{schema}';")
    results.each do |row|
      info = client.query("show create table #{schema}.#{row['table_name']};")
      info.each do |info_result|
        File.open("#{default_path}/views/#{row['table_name']}.sql", "w") {|f| f.write(info_result["Create View"]) }
      end
    end
  
    # Get all Triggers
    FileUtils.mkdir_p "#{default_path}/triggers"

    results = client.query("select trigger_name from information_schema.triggers where TRIGGER_SCHEMA = '#{schema}';")
    results.each do |row|
      info = client.query("show create trigger #{schema}.#{row['trigger_name']};")
      info.each do |info_result|
        File.open("#{default_path}/triggers/#{row['trigger_name']}.sql", "w") {|f| f.write(info_result["SQL Original Statement"]) }
      end
    end
  
    # Get all Functions
    FileUtils.mkdir_p "#{default_path}/functions"

    results = client.query("select routine_name from information_schema.routines where routine_type = 'function' and routine_schema = '#{schema}';")
    results.each do |row|
      info = client.query("show create function #{schema}.#{row['routine_name']};")
      info.each do |info_result|
        File.open("#{default_path}/functions/#{row['routine_name']}.sql", "w") {|f| f.write(info_result["Create Function"]) }
      end
    end
  
    # Get all Procedures
    FileUtils.mkdir_p "#{default_path}/procedures"
    
    results = client.query("select routine_name from information_schema.routines where routine_type = 'procedure' and routine_schema = '#{schema}';")
    results.each do |row|
      info = client.query("show create procedure #{schema}.#{row['routine_name']};")
      info.each do |info_result|
        File.open("#{default_path}/procedures/#{row['routine_name']}.sql", "w") {|f| f.write(info_result["Create Procedure"]) }
      end
    end

    # Get all Events
    FileUtils.mkdir_p "#{default_path}/events"

    results = client.query("select EVENT_NAME from information_schema.events where event_schema = '#{schema}';")
    results.each do |row|
      info = client.query("show create event #{schema}.#{row['EVENT_NAME']};")
      info.each do |info_result|
        File.open("#{default_path}/events/#{row['EVENT_NAME']}.sql", "w") {|f| f.write(info_result["EVENT_DEFINITION"]) }
      end
    end
  end
end

