class AnswerSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :body, :can_edit, :is_accepted_answer

  has_one :user
  has_one :question

  has_many :comments

  def can_edit
    object.user == scope
  end

  def is_accepted_answer
    object == object.question.accepted_answer
  end
end
