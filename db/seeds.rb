# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'ffaker'

Group.destroy_all

ActiveRecord::Base.connection.execute(
  "INSERT INTO groups
          WITH RECURSIVE groups AS
          (
              SELECT generate_series(1, 5) AS id, 
                    NULL :: int4 AS parent_id,
                    1 AS lvl,
                    CONCAT('Root Group ', generate_series(1, 5)) AS name
              UNION ALL
              SELECT n, 
                    id, 
                    lvl + 1,
                    CONCAT('Group ', n) 
              FROM groups, 
                  generate_series(power(5, lvl) :: int4 + (id - 1)*5 + 1,
                  power(5, lvl) :: int4 + (id -1)*5 + 5 ) g(n)
              WHERE lvl < 10
          )
          SELECT * FROM groups;"
)

