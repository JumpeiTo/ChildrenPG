# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザーの作成
Customer.create!([
  { email: "tarou@example.com", password: "password", name: "山田太郎", nickname: "やまたろ", is_deleted: false, is_hidden: false, profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.png"), filename: "sample-user1.png") },
  { email: "hanako@example.com", password: "password", name: "近藤花子", nickname: "はなちゃん", is_deleted: false, is_hidden: false, profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.png"), filename: "sample-user1.png") }
  # 他のユーザーデータを追加
])

Admin.create!([
  { email: "admin@example.com", password: "cpg2307" }
])

TargetAge.create!([
  { age: "何歳でも楽しめる" },
  { age: "0歳~3歳" },
  { age: "4歳~6歳" },
  { age: "小学校低学年" },
  { age: "小学校高学年" },
  { age: "中学生以上" }
])
