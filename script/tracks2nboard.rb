

abort "use:\nruby #$0 tracks_db >> seed.rb" unless ARGV.size == 1
tracks_db = %Q[mysql -s -u root -h localhost -D #{ARGV.first}]

UserID = 1 ### !!!
TracksUserID = 2 
StarredTagId = 4
LowPrioContext = 'nekdy'

SqlContexts = "select id, name, hide from contexts;"
sqlProjects = "select id, state, concat( '[', concat( name , ']' ) ), description from projects where state<>'completed' and user_id = #{TracksUserID};"
sqlActions = "select id, context_id, project_id, state, adddate(date(due),1), date(created_at), concat( '[', concat( description, ']' ) ), notes from todos where state<>'completed' and user_id = #{TracksUserID};"
sqlStarred = "select count(*) from taggings where taggable_type='Todo' and tag_id=#{StarredTagId} and taggable_id="
SqlNotes = "select body from notes where project_id="
SqlTags = "select t.name from tags t, taggings g where t.id=g.tag_id and g.taggable_type='Todo' and g.taggable_id="

puts "\n# encoding: utf-8" #required!
puts "c = {}"
puts "b = {}"
puts "u = User.find(#{UserID})"
b = {}
c = {}
low = []

%x{ echo "#{SqlContexts}" | #{tracks_db} }.each_line do |line|
   all, id, name, hide = /^(\d+)\s+(\S+)\s+(\d)$/.match(line.strip).to_a
   abort line if all.nil?

   puts "c[#{id}] = Context.create( :user_id => #{UserID}, :name => '#{name}', :active => #{ hide == '0'} )"

   c[id] = false 
   low << id if name == LowPrioContext
end

%x{ echo "#{sqlProjects}" | #{tracks_db} }.each_line do |line|
   all, id, state, name, desc = /^(\d+)\s+(\S+)\s+\[([^\]]+)\]\s*(.*)$/.match(line.strip).to_a
   abort line if all.nil?

   name = name[0...40]

   desc = '' if desc == 'NULL'
   desc += %x{ echo "#{SqlNotes}#{id}" | #{tracks_db} }.gsub(/\n/,'\n')
   desc = %Q[, :description => "#{desc.gsub('"',"'")}"] unless desc.empty? 

   puts %Q[b[#{id}] = Board.create( :user_id => #{UserID}, :title => "#{name.gsub('"',"'")}", :visibility => #{ state == 'active' ? 1 : 0 }#{desc}).id]
   puts "Permission.privs.each { |p| u.grant( p, b[#{id}] ) }"
  
   b[id] = 1
end

puts "b['NULL'] = Board.create( :user_id => #{UserID}, :title => 'misc', :visibility => 1).id"
puts "Permission.privs.each { |p| u.grant( p, b['NULL'] ) }"
puts "u.save"
b['NULL'] = 1

%x{ echo "#{sqlActions}" | #{tracks_db} }.each_line do |line|
   all,  id, context_id, project_id, state, due, created, title, content = /^(\d+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+\[([^\]]+)\]\s*(.+)?$/.match(line.strip).to_a
   abort line if all.nil?
   next unless b.has_key? project_id

   title = title[0...40]

   content = '' if content.nil? || content == 'NULL' 
   content.gsub!( /(http\:\/\/\S+)/, %Q["\\1":\\1] )
   content.gsub!(/\n/,'\n')

   due = (due == 'NULL') ? 'nil' : "'#{due}'"
   project_id = "'NULL'" if project_id == 'NULL' 
   prio = ( %x{ echo "#{sqlStarred}#{id}" | #{tracks_db} }.strip == '1' ) ? 2 : 1
   prio = 0 if low.include? context_id

   puts %Q[\nn = Note.create :board_id => b[#{project_id}], :user_id => #{UserID}, :title => "#{title.gsub('"',"'")}", :content => %Q{#{content}}, :priority => #{prio}, :working => false, :problem => false, :instant_date => #{due}]
   puts "n.contexts << c[#{context_id}]\nn.save"
#  puts %Q{ActiveRecord::Base.connection.execute("insert into contexts_notes( note_id, context_id ) values ( " + n.id.to_s + ", " + c[#{context_id}].id.to_s + " );")} 
#  puts %Q{puts "insert into contexts_notes( note_id, context_id ) values ( " + n.id.to_s + ", " + c[#{context_id}].id.to_s + " );"}   
   
   tags =  %x{ echo "#{SqlTags}#{id}" | #{tracks_db} }.split(/\n/).join(', ')
   puts %Q[Change.create :note => n, :user_id => #{UserID},  :meaning => 6, :comment => 'tracks: #{tags}', :created => '#{created}']

   c[context_id] = true 
end

c.each_pair do |ctx,active|
  puts "c[#{ctx}].active = false\nc[#{ctx}].save" unless active
 # puts %Q{puts c[#{ctx}].name + " osc=#{ctx} id=" +  c[#{ctx}].id.to_s} unless active
end


