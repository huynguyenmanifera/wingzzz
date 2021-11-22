Publisher.destroy_all

puts '***** Adding publishers *****'

10.times do
  name = Faker::Book.unique.publisher
  puts "[Publisher] Adding '#{name}'"
  Publisher.create(name: name)
end
