# 
# = Capistrano database.yml task
#
# Provides a couple of tasks for creating the database.yml 
# configuration file dynamically when deploy:setup is run.
#
# Category::    Capistrano
# Package::     Database
# Author::      Simone Carletti <weppos@weppos.net>
# Copyright::   2007-2010 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
#
#
# == Requirements
#
# This extension requires the original <tt>config/database.yml</tt> to be excluded
# from source code checkout. You can easily accomplish this by renaming
# the file (for example to database.example.yml) and appending <tt>database.yml</tt>
# value to your SCM ignore list.
#
#   # Example for Subversion
#
#   $ svn mv config/database.yml config/database.example.yml
#   $ svn propset svn:ignore 'database.yml' config
#
#   # Example for Git
#
#   $ git mv config/database.yml config/database.example.yml
#   $ echo 'config/database.yml' >> .gitignore 
#
# 
# == Usage
# 
# Include this file in your <tt>deploy.rb</tt> configuration file.
# Assuming you saved this recipe as capistrano_database_yml.rb:
# 
#   require "capistrano_database_yml"
# 
# Now, when <tt>deploy:setup</tt> is called, this script will automatically
# create the <tt>database.yml</tt> file in the shared folder.
# Each time you run a deploy, this script will also create a symlink
# from your application <tt>config/database.yml</tt> pointing to the shared configuration file. 
# 
# == Custom template
# 
# By default, this script creates an exact copy of the default
# <tt>database.yml</tt> file shipped with a new Rails 2.x application.
# If you want to overwrite the default template, simply create a custom Erb template
# called <tt>database.yml.erb</tt> and save it into <tt>config/deploy</tt> folder.
# 
# Although the name of the file can't be changed, you can customize the directory
# where it is stored defining a variable called <tt>:template_dir</tt>.
# 
#   # store your custom template at foo/bar/database.yml.erb
#   set :template_dir, "foo/bar"
# 
#   # example of database template
#   
#   base: &base
#     adapter: sqlite3
#     timeout: 5000
#   development:
#     database: #{shared_path}/db/development.sqlite3
#     <<: *base
#   test:
#     database: #{shared_path}/db/test.sqlite3
#     <<: *base
#   production:
#     adapter: mysql
#     database: #{application}_production
#     username: #{user}
#     password: #{Capistrano::CLI.ui.ask("Enter MySQL database password: ")}
#     encoding: utf8
#     timeout: 5000
#
# Because this is an Erb template, you can place variables and Ruby scripts
# within the file.
# For instance, the template above takes advantage of Capistrano CLI
# to ask for a MySQL database password instead of hard coding it into the template.
#
# === Password prompt
#
# For security reasons, in the example below the password is not
# hard coded (or stored in a variable) but asked on setup.
# I don't like to store passwords in files under version control
# because they will live forever in your history.
# This is why I use the Capistrano::CLI utility.
#

