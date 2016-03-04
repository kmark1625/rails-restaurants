# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed sample input files
inputfile1 = Inputfile.create(name: "Sample Menu 1", description: "Original menu including with the challenge", attachment: Rails.root.join("public/sample/SampleMenu1.txt").open)
inputfile2 = Inputfile.create(name: "Sample Menu 2", description: "Menu with a large number of items", attachment: Rails.root.join("public/sample/SampleMenu2.txt").open)
inputfile3 = Inputfile.create(name: "Sample Menu 3", description: "Menu with a large target price", attachment: Rails.root.join("public/sample/SampleMenu3.txt").open)