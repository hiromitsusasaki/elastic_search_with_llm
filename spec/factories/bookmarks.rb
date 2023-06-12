# == Schema Information
#
# Table name: bookmarks
#
#  id                   :bigint           not null, primary key
#  created_in_source_at :datetime
#  description          :text(65535)
#  identifier_in_source :integer
#  title                :text(65535)
#  updated_in_source_at :datetime
#  url                  :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :bookmark do
    
  end
end
