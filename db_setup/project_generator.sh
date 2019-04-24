#!/usr/bin/env bash

rm -rf storage/

docker run -p 3306:3306 --name bukinist-db57-dev -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7

#docker ps -a
#docker start ...

#docker exec -u 0 -it bukinist-db57-dev bash
#mysql -u root -ppassword

mysql -h 127.0.0.1 -u root -ppassword
# do the db_generator.sql
mysql -h 127.0.0.1 -u catalog -pcatalog

docker run --name myadmin -d --link bukinist-db57-dev:db -p 81:80 phpmyadmin/phpmyadmin


rails new catalog
cd catalog
bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java
bundle install

#setup mysql

rails g controller books new create update edit destroy index show

#generate all models
rails g model work\
 title:string

rails g model author\
 name:string

rails g migration create_join_table_works_authors works authors

rails g model interpreter\
 name:string

rails g migration create_join_table_works_interpreters works interpreters

rails g model book\
 hash_id:string:index\
 title:string\
 pages:integer\
 year:integer\
 format:integer\
 isbn:string\
 volume:integer\
 volumes:integer\
 price:string\
 is_new:boolean\
 condition:integer\
 publisher_id:integer\
 serie_id:integer\
 language_id:integer

rails g model publisher\
 name:string

rails g model serie\
 name:string

rails g model language\
 name:string

rails g migration create_join_table_books_works books works

#https://guides.rubyonrails.org/active_storage_overview.html
rails active_storage:install
rake db:migrate

rails g migration add_city_to_publishers city:string
rails g migration add_country_to_publishers country:string
rails g migration add_website_to_publishers website:string

rails g migration rename_book_year_to_book_year_published
#  rename_column :books, :year, :year_published

rails g migration rename_format_name_to_format_cover
#  rename_column :formats, :name, :cover

rails g migration add_circulation_to_books circulation:string
rails g migration add_descriprion_to_books descriprion:string
rails g migration add_quantity_to_books quantity:integer

rails g migration rename_work_title_to_work_name
#  rename_column :works, :title, :name


rails g migration add_type_to_works type:string
rails g migration add_abstract_to_works abstract:string
rails g migration add_year_to_works year:integer


rails g migration rename_book_descriprion_to_book_description
#  rename_column :works, :descriprion, :description

rails g migration create_join_table_books_publishers books publishers
rails g migration remove_publisher_id_from_books publisher_id:integer

rails g migration add_format_to_formats format:string


rails g migration rename_work_type_to_work_major_form
#  rename_column :works, :type, :major_form


rails g migration add_language_to_works language:string
rails g migration change_abstract_to_be_text_in_works

rails g scaffold bulk_insert_list\
 hash_id:string:index\
 EAN13:text

rails g migration add_EAN13_to_books EAN13:string

rails generate delayed_job:active_record
rails generate progress_job:install
rake db:migrate

rails g migration add_approved_to_books approved:boolean

rails g model isbn\
 value:string\
 book_id:integer
