class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :accepted_answer, class_name: 'Answer'

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, length: { in: 30..10000 }
  validates :title, length: { in: 15..150 }
  validates :user, presence: true
  validate :accepted_answer_belongs_to_question

  def accepted_answer_belongs_to_question
    if accepted_answer && accepted_answer.question != self
      errors.add(:accepted_answer, "must be in response to this question")
    end
  end
end
