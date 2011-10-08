# encoding: utf-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

admin =User.find_or_create_by_email(
    :name => 'admin',
    :email => 'admin@example.com',
    :send_mails => false,
    :password => 'password',
    :password_confirmation => 'password')
admin.save

Permission.privs.each { |p| admin.grant p }
