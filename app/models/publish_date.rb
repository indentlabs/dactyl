class PublishDate < ApplicationRecord
  belongs_to :publisher
  belongs_to :author
  belongs_to :book

  has_many :hosted_corpus, dependent: :destroy
end
