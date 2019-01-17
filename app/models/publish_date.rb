class PublishDate < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  belongs_to :book
end
