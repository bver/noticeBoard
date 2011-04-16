# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

rights = []
rights << Privilege.create( :name=>'manage_users', :description=>'create/edit/disable accounts, grant/revoke privileges' )
rights << Privilege.create( :name=>'add_boards', :description=>'create new boards, edit/disable created boards' )
rights << Privilege.create( :name=>'manage_boards', :description=>'edit/disable all boards' )
rights << Privilege.create( :name=>'urgent_prio', :description=>'change priorities, including urgent level' )

rights << Privilege.create( :name=>'view_board', :description=>'see notes on board', :board=>true )
rights << Privilege.create( :name=>'edit_notes', :description=>'create/edit notes on board', :board=>true )
rights << Privilege.create( :name=>'cancel_notes', :description=>'cancel notes', :board=>true )
rights << Privilege.create( :name=>'assign_notes', :description=>'assign/unassign notes to/from users', :board=>true )
rights << Privilege.create( :name=>'change_prio', :description=>'change priorities, except urgent level', :board=>true )

admin =User.find_or_create_by_email(
    :name => 'admin',
    :email => 'admin@example.com',
    :send_mails => false,
    :password => 'password',
    :password_confirmation => 'password')
admin.save

rights.each {|privilege| UserPriv.create( :user_id=>admin.id, :privilege_id=>privilege.id ) }
